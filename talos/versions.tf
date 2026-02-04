terraform {
  required_providers {
    xenorchestra = {
      source  = "vatesfr/xenorchestra"
      version = "0.37.2"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
    }
  }
}

# Configure the Xen Orchestra Provider
provider "xenorchestra" {
  url      = "ws://${var.xoa_url}"
  username = var.xoa_username
  password = var.xoa_password

  insecure = true
}

provider "talos" {}

