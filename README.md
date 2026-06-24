# Azure secure architecture Terraform

This directory contains Terraform code to provision:

- Resource group
- Virtual network with two subnets
- Standard Public IP + Standard Load Balancer
- Two Ubuntu Linux VMs, each in its own subnet, behind the LB
- Network Security Group allowing only traffic from Azure Load Balancer to VMs
- NAT Gateway for outbound Internet access
- SSH keypair generated locally

Usage:

1. Install Terraform.
2. Authenticate to Azure (e.g., `az login`).
3. From this folder run:

```powershell
terraform init
terraform apply
```

After apply completes, see outputs for `lb_ip` and `ssh_command` and the generated `id_rsa` key.
