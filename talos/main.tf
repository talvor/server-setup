locals {
  size_1GB            = 1024 * 1024 * 1024
  cluster_endpoint    = var.cluster_endpoint != null ? var.cluster_endpoint : "https://${var.cluster_vip}:6443"
  cluster_ip          = var.cp_settings[0].ip_address
  talos_install_image = "factory.talos.dev/nocloud-installer/${var.talos_image_id}:${var.talos_version}"
}

data "xenorchestra_pool" "this" {
  name_label = var.pool_name
}

data "xenorchestra_sr" "this" {
  name_label = var.sr_name
  pool_id    = data.xenorchestra_pool.this.id
}
data "xenorchestra_template" "this" {
  name_label = var.vm_template
  pool_id    = data.xenorchestra_pool.this.id
}

data "xenorchestra_network" "this" {
  name_label = var.network_name
  pool_id    = data.xenorchestra_pool.this.id
}

data "xenorchestra_vdi" "iso" {
  count      = var.iso_name != null ? 1 : 0
  name_label = var.iso_name
  pool_id    = data.xenorchestra_pool.this.id
}

resource "xenorchestra_vm" "cp" {
  memory_max       = var.cp_memory_gb * local.size_1GB
  cpus             = var.cp_cpus
  name_label       = format("talos-cp-%02s", count.index + 1)
  name_description = "Talos Controlplane created with Terraform"
  template         = data.xenorchestra_template.this.id

  affinity_host = var.hosts[var.cp_settings[count.index].target_host].id

  hvm_boot_firmware = "uefi"
  secure_boot       = false
  power_state       = "Running"

  dynamic "cdrom" {
    for_each = var.iso_name != null ? [1] : []
    content {
      id = data.xenorchestra_vdi.iso[0].id
    }
  }

  network {
    network_id       = data.xenorchestra_network.this.id
    expected_ip_cidr = var.expected_ip_cidr
  }

  disk {
    sr_id      = var.hosts[var.cp_settings[count.index].target_host].storage
    name_label = format("talos-cp-%02s", count.index + 1)
    size       = var.cp_disk_size_gb * local.size_1GB
  }


  count = length(var.cp_settings)
}

resource "xenorchestra_vm" "worker" {
  memory_max       = var.worker_memory_gb * local.size_1GB
  cpus             = var.worker_cpus
  name_label       = format("talos-wk-%02s", count.index + 1)
  name_description = "Talos Worker created with Terraform"
  template         = data.xenorchestra_template.this.id

  hvm_boot_firmware = "uefi"
  secure_boot       = false
  power_state       = "Running"

  affinity_host = var.hosts[var.worker_settings[count.index].target_host].id

  dynamic "cdrom" {
    for_each = var.iso_name != null ? [1] : []
    content {
      id = data.xenorchestra_vdi.iso[0].id
    }
  }

  network {
    network_id       = data.xenorchestra_network.this.id
    expected_ip_cidr = var.expected_ip_cidr
  }

  disk {
    sr_id      = var.hosts[var.worker_settings[count.index].target_host].storage
    name_label = format("talos-wk-%02s", count.index + 1)
    size       = var.worker_disk_size_gb * local.size_1GB
  }

  disk {
    sr_id      = data.xenorchestra_sr.this.id
    name_label = format("talos-wk-%02s-data", count.index + 1)
    size       = 100 * local.size_1GB
  }

  count = length(var.worker_settings)
}

# Talos cluster configuration
resource "talos_machine_secrets" "this" {}

# Generate machine configurations in order to get the cloud-init userdata
data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [local.cluster_ip]

  depends_on = [xenorchestra_vm.cp]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  count                       = length(xenorchestra_vm.cp)
  node                        = xenorchestra_vm.cp[count.index].network[0].ipv4_addresses[0]
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/xvda"
          image = local.talos_install_image
        }
        network = {
          interfaces = [
            {
              interface = "enX0"
              addresses = ["${var.cp_settings[count.index].ip_address}/24"]
              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = "192.168.1.1"
                  metric  = 1024
                }
              ]
              mtu = 1500
            }
          ]
        }
      }
    })
  ]

  depends_on = [xenorchestra_vm.cp]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  count                       = length(xenorchestra_vm.worker)
  node                        = xenorchestra_vm.worker[count.index].network[0].ipv4_addresses[0]
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/xvda"
          image = local.talos_install_image
        }
        network = {
          interfaces = [
            {
              interface = "enX0"
              addresses = ["${var.worker_settings[count.index].ip_address}/24"]
              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = "192.168.1.1"
                  metric  = 1024
                }
              ]
              mtu = 1500
            }
          ]
        }
      }
    })
  ]

  depends_on = [xenorchestra_vm.worker]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.cluster_ip

  depends_on = [talos_machine_configuration_apply.controlplane]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.cluster_ip

  depends_on = [talos_machine_bootstrap.this]
}
