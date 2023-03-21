## common

location        = "westus"
namespace       = "emqx"
additional_tags = {}

## vnet

emqx_address_space = "10.0.0.0/16"

## vm

emqx_vm_size = "Standard_F2s_v2"
emqx_package = "https://www.emqx.com/en/downloads/enterprise/4.4.16/emqx-ee-4.4.16-otp24.3.4.2-1-ubuntu20.04-amd64.zip"

## SSL/TLS

enable_ssl_two_way    = false
ca_common_name        = "RootCA"
common_name           = "Server"
org                   = "EMQ"
validity_period_hours = 8760
early_renewal_hours   = 720
