terraform {
  required_providers {
    xenorchestra = {
      source  = "vatesfr/xenorchestra"
      version = "0.37.2"
    }

    butane = {
      source  = "KeisukeYamashita/butane"
      version = "0.1.4"
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


