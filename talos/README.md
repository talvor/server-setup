# Talos Cluster Setup

This directory contains Terraform configurations and a Makefile for setting up and managing a Talos Kubernetes cluster. It allows you to automate the provisioning of both Control Plane and Worker nodes, ensuring a streamlined deployment process.

---

## Purpose
The main purpose of this directory is to:
- Automate the provisioning of Talos Control Plane and Worker nodes.
- Manage associated infrastructure, such as storage and networking.
- Provide an easy-to-use interface via the Makefile to simplify operations.

---

## Terraform Variables Setup
The `variables.tf` file defines all configurable parameters for the cluster setup. Some key variables include:

- **cluster_name**: Name of the Talos cluster.
- **cp_settings**: A list of Control Plane settings:
  - **target_node**: The target compute node.
  - **ip_address**: The assigned IP address for the Control Plane.
- **worker_settings**: A list of Worker node settings similar to `cp_settings`.
- **hosts**: Maps target hostnames to Xen Orchestra IDs and storage IDs.
- **cluster_vip**: The Virtual IP used for cluster communication.

Refer to the `variables.tf` file for more details. Values should be provided in a `terraform.tfvars` file.

---

## Makefile Usage
The Makefile simplifies the Terraform operations required to set up and manage the Talos cluster. Below are the available commands:

### make install-tools
- Installs all necessary tools, such as opentofu, helm, jq, kubectl, and talosctl. Skips installation for already installed tools.

### make init
- Initializes the Terraform working directory.

### make plan
- Generates an execution plan for Terraform, displaying the changes that will be applied.

### make apply
- Applies the Terraform configurations to provision the Talos Control Plane and Worker nodes.

### make destroy
- Destroys all the Terraform-managed infrastructure in this directory.

### make read-kubeconfig
- Outputs the Kubernetes kubeconfig file to `~/.kube/config` for cluster interaction.

### make read-talosconfig
- Outputs the Talos configuration to `./talos/talosconfig` for managing the cluster.

---

## Example Usage
1. **Set up variables**: Create and populate `terraform.tfvars` with the required values for your setup.
2. **Deploy the Talos Cluster**: Run the following commands:
   ```bash
   make init
   make apply
   ```
3. **Access the Cluster**:
   - Update your Kubernetes configuration:
     ```bash
     make read-kubeconfig
     ```
   - Update your Talos configuration:
     ```bash
     make read-talosconfig
     ```
4. **Destroy the Cluster** (if necessary):
   ```bash
   make destroy
   ```

