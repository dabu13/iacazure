output "lb_ip" {
  description = "Public IP of the load balancer"
  value       = azurerm_public_ip.lb_pip.ip_address
}

output "ssh_command" {
  description = "Example SSH command to connect via load balancer"
  value       = "ssh -i ${local_file.private_key.filename} ${var.admin_username}@${azurerm_public_ip.lb_pip.ip_address}"
}
