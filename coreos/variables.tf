variable "xoa_url" {
  description = "Xen Orchestra server address"
  type        = string
}
variable "xoa_username" {
  description = "Xen Orchestra username"
  type        = string
}
variable "xoa_password" {
  description = "Xen Orchestra password"
  type        = string
  sensitive   = true
}

variable "coreos_tmpl_id" {
  description = "CoreOS template ID"
  type        = string
}

variable "pool_name" {
  description = "Pool name label"
  type        = string
  default     = "homelab"
}

variable "sr_name" {
  description = "Shared storage name label"
  type        = string
}

variable "network_name" {
  description = "Network name label"
  type        = string
}

variable "expected_ip_cidr" {
  description = "Determines the IP CIDR range the provider will wait for on this network interface."
  type        = string
}

variable "ssh_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "gateway_address" {
  description = "Gateway IP address for the VM network"
  type        = string
}

variable "dns_server" {
  description = "DNS server IP address"
  type        = string
  default     = "8.8.8.8"
}

variable "vm_settings" {
  description = "VM settings"
  type = list(object({
    name        = string
    description = string
    cpus        = number
    memory_gb   = number
    disk_gb     = number
    target_node = string
    ip_address  = string
  }))
  default = []
}

