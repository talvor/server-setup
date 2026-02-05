
locals {
  size_1GB = 1024 * 1024 * 1024
}

data "xenorchestra_pool" "pool" {
  name_label = var.pool_name
}

data "xenorchestra_sr" "shared_storage" {
  name_label = var.sr_name
}

data "xenorchestra_network" "net" {
  name_label = var.network_name
  pool_id    = data.xenorchestra_pool.pool.id
}

data "xenorchestra_hosts" "hosts" {
  pool_id = data.xenorchestra_pool.pool.id
}

data "butane_config" "config" {
  for_each = { for vm in var.vm_settings : vm.name => vm }
  content = templatefile(
    each.value.config_template,
    merge(
      {
        ssh_key    = var.ssh_key
        hostname   = each.value.name
        ip_address = each.value.ip_address
        gateway    = var.gateway_address
        dns_server = var.dns_server
      },
    each.value.config_variables)
  )
  pretty = true
}

resource "xenorchestra_vm" "vm" {
  for_each         = { for vm in var.vm_settings : vm.name => vm }
  memory_max       = each.value.memory_gb * local.size_1GB
  cpus             = each.value.cpus
  name_label       = each.value.name
  name_description = each.value.description
  template         = var.coreos_tmpl_id
  cloud_config     = data.butane_config.config[each.key].ignition

  affinity_host = [
    for host in data.xenorchestra_hosts.hosts.hosts : host
    if host.name_label == each.value.target_node
  ][0].id

  hvm_boot_firmware = "uefi"
  secure_boot       = false
  power_state       = "Running"

  network {
    network_id = data.xenorchestra_network.net.id
    # expected_ip_cidr = var.expected_ip_cidr
  }

  disk {
    sr_id      = data.xenorchestra_sr.shared_storage.id
    name_label = "${each.value.name} disk"
    size       = each.value.disk_gb * local.size_1GB
  }
}

