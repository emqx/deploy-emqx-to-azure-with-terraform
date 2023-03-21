#######################################
# common
#######################################

resource "random_id" "name" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.namespace}_${random_id.name.hex}_resource_group"

  tags = merge(var.additional_tags, {
    source = "terraform"
  })
}


#######################################
# security group modules
#######################################

module "emqx_network_security_group" {
  source = "../../modules/network_security_group"

  namespace           = var.namespace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rules      = var.emqx_security_rules
  additional_tags     = var.additional_tags
}


#######################################
# network modules
#######################################

module "emqx_network" {
  source = "../../modules/network"

  vm_count            = 1
  namespace           = var.namespace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_conf         = var.subnet_conf
  address_space       = var.emqx_address_space
  nsg_id              = module.emqx_network_security_group.nsg_id
  additional_tags     = var.additional_tags
}

#######################################
# emqx cluster modules
#######################################

module "self_signed_cert" {
  source = "../../modules/self_signed_cert"

  ca_common_name        = var.ca_common_name
  common_name           = var.common_name
  org                   = var.org
  early_renewal_hours   = var.early_renewal_hours
  validity_period_hours = var.validity_period_hours
}

#######################################
# emqx modules
#######################################

module "emqx" {
  source = "../../modules/emqx"

  namespace           = var.namespace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  nic_ids             = module.emqx_network.nic_ids
  vm_size             = var.emqx_vm_size
  emqx_package        = var.emqx_package
  emqx_lic            = var.emqx_lic
  additional_tags     = var.additional_tags

  # SSL/TLS
  enable_ssl_two_way = var.enable_ssl_two_way
  key                = module.self_signed_cert.key
  cert               = module.self_signed_cert.cert
  ca                 = module.self_signed_cert.ca
}
