output "emqx_public_ip" {
  description = "the public ip of emqx"
  value       = module.emqx.public_ip
}

output "ssh_key" {
  description = "the ssh key of vm"
  value       = module.emqx.tls_private_key
  sensitive   = true
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
