# Home Server Lab Configuration

This repository provides configurations for setting up and managing a home server lab. It uses Terraform and Makefiles to automate the deployment and maintenance of virtual machines with CoreOS and Talos operating systems, enabling an efficient and manageable server environment.

---

## Repository Structure
### CoreOS Directory
The CoreOS directory contains configurations for provisioning CoreOS virtual machines. These VMs are configured with Ignition (via Butane) for cloud-config-style initialization, making them ideal for container workloads or other lightweight services.
- Refer to the `coreos/README.md` for detailed setup instructions.

### Talos Directory
The Talos directory contains configurations for setting up and managing a Kubernetes cluster using Talos. It provisions both Control Plane and Worker nodes as part of a highly automated K8s setup.
- Refer to the `talos/README.md` for deployment details.

---

## Top-Level Makefile Usage
The top-level Makefile provides entry points for working with the subdirectories (`coreos` and `talos`). It proxies Make commands to the appropriate subdirectory. Below are the available commands:

### make coreos <command>
- Executes a Make command in the `coreos` directory.
- Example: To apply CoreOS configurations, run:
  ```bash
  make coreos apply
  ```

### make talos <command>
- Executes a Make command in the `talos` directory.
- Example: To apply Talos configurations, run:
  ```bash
  make talos apply
  ```

