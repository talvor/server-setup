# CoreOS Setup

This directory contains Terraform configurations and supporting files for setting up CoreOS virtual machines (VMs) in a Xen Orchestra environment. It enables the creation of CoreOS VMs with custom configurations, including SSH access and network setup.

---

## Purpose
The main goal of this directory is to automate the deployment of CoreOS VMs, including their:
- Resource allocation (CPU, Memory, Disk)
- Configuration (using Ignition through Butane)
- Networking and storage setup.

This is achieved using Terraform and a Makefile for command automation.

---

## Terraform Variables Setup
The `variables.tf` file defines all the configurable parameters for the setup. Some key variables are:

- **coreos_tmpl_id**: ID of the CoreOS template used for VM creation.
- **vm_settings**: A list of objects specifying VM details, such as name, CPU, memory, disk size, and IP address.
- **pool_name, sr_name, network_name**: Names for the Xen Orchestra pool, shared storage, and network.
- **ssh_key**: Public SSH key for VM access.
- **gateway_address**: Gateway IP address used for networking configuration.
- **dns_server**: DNS server for the VMs.

Refer to `variables.tf` for more details and provide values in a `terraform.tfvars` file.

---

## Makefile Usage
The Makefile in this directory automates common tasks, such as initializing the Terraform setup and applying configurations. Below are the available commands:

### make init
- Initializes the Terraform working directory.

### make plan
- Generates and displays an execution plan for Terraform.

### make apply
- Converts Butane configurations to Ignition and applies the Terraform configurations to deploy the CoreOS VMs.

### make destroy
- Destroys all the Terraform-managed infrastructure in this directory.

---

## Example Usage
1. **Set up variables**: Create a `terraform.tfvars` file with values for all required variables.
2. **Deploy the VMs**: Run:
   ```bash
   make init
   make apply
   ```
   This will initialize Terraform, convert Butane configurations, and apply the configurations.
3. **Destroy the VMs**: Run:
   ```bash
   make destroy
   ```

