output "key" {
  value = tls_private_key.ca.private_key_pem
}

output "cert" {
  value = tls_locally_signed_cert.default.cert_pem
}

output "ca" {
  value = tls_self_signed_cert.ca.cert_pem
}
