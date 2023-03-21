######################################
## create a ca certificate
######################################

resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  validity_period_hours = var.validity_period_hours
  early_renewal_hours   = var.early_renewal_hours
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]

  subject {
    common_name  = var.ca_common_name
    organization = var.org
  }
}

######################################
## create a tls cerfiticate signed by ca
######################################

resource "tls_cert_request" "cert" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = var.common_name
    organization = var.org
  }
}

resource "tls_locally_signed_cert" "default" {
  cert_request_pem   = tls_cert_request.cert.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem


  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]
}
