output "loadbalancer_public_ip" {
  description = "The public ip address for loadbalancer resource"
  value       = module.emqx_lb.azurerm_lb_public_ip_address
}

output "loadbalancer_private_ip" {
  description = "The private ip address for loadbalancer resource"
  value       = module.emqx_lb.azurerm_lb_private_ip_address
}

output "tls_key" {
  description = "The key for self signed certificate"
  value       = module.self_signed_cert.key
  sensitive   = true
}

output "tls_cert" {
  description = "The cert for self signed certificate"
  value       = module.self_signed_cert.cert
  sensitive   = true
}

output "tls_ca" {
  description = "The ca for self signed certificate"
  value       = module.self_signed_cert.ca
  sensitive   = true
}
