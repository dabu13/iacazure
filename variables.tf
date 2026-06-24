variable "prefix" {
  type    = string
  default = "demo"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2als_v7"
  description = "Default VM size set to a Gen2-capable SKU (2 vCPU, ~4GB)"
}

variable "ssh_public_key" {
  type    = string
  default = ""
  description = "Provide an SSH public key. If empty, terraform will generate one."
}

variable "resource_group_name" {
  type    = string
  default = ""
  description = "Optional: specify an existing resource group name to use instead of creating one"
}

variable "hyper_v_generation" {
  type    = string
  default = "V1"
  description = "Set to \"V2\" to create generation 2 (Hyper-V Gen2) VMs when supported"
}
