output "public_ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "private_ip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}