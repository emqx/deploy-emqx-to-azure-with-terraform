output "nsg_id" {
  description = "the ID of the Network Security Group"
  value       = azurerm_network_security_group.nsg.id
}
