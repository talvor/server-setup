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

variable "vm_template" {
  description = "Xen Orchestra VM template name to clone from"
  type        = string
}

variable "iso_name" {
  description = "ISO name label to mount on control plane nodes (optional). If provided, will also add /machine/install patches."
  type        = string
  default     = null
}

variable "pool_name" {
  description = "Pool name label"
  type        = string
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

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "demo-talos"
}

variable "cluster_vip" {
  description = "The virtual IP for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster (defaults to https://<cluster_vip>:6443)"
  type        = string
  default     = null
}

variable "cp_cpus" {
  description = "Number of CPUs for control plane"
  type        = number
  default     = 2
}

variable "cp_memory_gb" {
  description = "Memory size for control plane in GB"
  type        = number
  default     = 4
}

variable "cp_disk_size_gb" {
  description = "Control plane disk size in GB"
  type        = number
  default     = 20
}

variable "cp_settings" {
  description = "Control plane settings"
  type = list(object({
    target_host = string
    ip_address  = string
  }))
  default = []
}

variable "worker_cpus" {
  description = "Number of CPUs for worker"
  type        = number
  default     = 2
}

variable "worker_memory_gb" {
  description = "Memory size for worker in GB"
  type        = number
  default     = 4
}

variable "worker_disk_size_gb" {
  description = "Worker disk size in GB"
  type        = number
  default     = 20
}

variable "worker_settings" {
  description = "Worker settings"
  type = list(object({
    target_host = string
    ip_address  = string
  }))
  default = []
}

variable "talos_version" {
  description = "Talos version to install (iso installation only)"
  type        = string
}

variable "hosts" {
  description = "Mapping of target host names to their IDs and storage IDs"
  type = map(object({
    id      = string
    storage = string
  }))
  default = {}
}
