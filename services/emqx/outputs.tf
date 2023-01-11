output "emqx_public_ip" {
  description = "the public ip of emqx"
  value       = module.emqx.public_ip
}

output "tls_private_key" {
  description = "the private key of emqx vm"
  value     =  module.emqx.tls_private_key
  sensitive = true
}