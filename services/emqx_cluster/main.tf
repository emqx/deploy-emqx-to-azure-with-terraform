#######################################
# common
#######################################

resource "random_id" "name" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.namespace}_${random_id.name.hex}_resource_group"
}

#######################################
# security group modules
#######################################

module "emqx_network_security_group" {
  source = "../../modules/network_security_group"

  namespace = var.namespace
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rules = var.emqx_security_rules
  additional_tags = var.additional_tags
}

#######################################
# network modules
#######################################

module "emqx_network" {
  source = "../../modules/network"

  vm_count = var.emqx_vm_count
  namespace = var.namespace
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_conf = var.subnet_conf
  address_space = var.emqx_address_space
  nsg_id = module.emqx_network_security_group.nsg_id
  additional_tags = var.additional_tags
}


#######################################
# emqx cluster modules
#######################################

module "emqx_cluster" {
  source = "../../modules/emqx_cluster"

  namespace                   = var.namespace
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  nic_ids = module.emqx_network.nic_ids
  vm_count = var.emqx_vm_count
  vm_size = var.emqx_vm_size
  emqx_package = var.emqx_package
  emqx_lic = var.emqx_lic
  additional_tags = var.additional_tags
}


#######################################
#  loadbalancer modules
#######################################

module "emqx_lb" {
  source                                 = "../../modules/loadbalancer"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  type                                   = var.lb_type
  frontend_subnet_id                     = var.lb_type == "private" ? module.emqx_network.subnet_ids[1] : ""
  frontend_name = "lb-ip"
  vnet_id = module.emqx_network.vnet_id
  emqx_private_ips = module.emqx_cluster.emqx_private_ips
  lb_sku                                 = "Standard"
  pip_sku                                = "Standard"
  name                                   = "emqx-lb"
  pip_name                               = "emqx-public-ip"


  lb_port = var.lb_port
  lb_probe = var.lb_probe

  additional_tags = var.additional_tags

  depends_on = [azurerm_resource_group.rg]
}



