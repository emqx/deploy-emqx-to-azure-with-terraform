
output "azurerm_lb_public_ip_address" {
  description = "the ip address for the azurerm_lb_public_ip resource"
  value       = var.type == "public" ? azurerm_public_ip.azlb[0].ip_address : ""
}

output "azurerm_lb_private_ip_address" {
  description = "the ip address for the load balancer resource"
  value       = var.type == "public" ? "" : azurerm_lb.azlb_private[0].frontend_ip_configuration[0].private_ip_address
}
