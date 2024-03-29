# Azure load balancer module
data "azurerm_resource_group" "azlb" {
  name = var.resource_group_name
}

locals {
  lb_name  = var.name != "" ? var.name : format("%s-lb", var.prefix)
  pip_name = var.pip_name != "" ? var.pip_name : format("%s-publicIP", var.prefix)
}

resource "azurerm_public_ip" "azlb" {
  count               = var.type == "public" ? 1 : 0
  name                = local.pip_name
  resource_group_name = data.azurerm_resource_group.azlb.name
  location            = coalesce(var.location, data.azurerm_resource_group.azlb.location)
  allocation_method   = var.allocation_method
  sku                 = var.pip_sku

  tags = merge(var.additional_tags, {
    source = "terraform"
  })
}

resource "azurerm_lb" "azlb_public" {
  count               = var.type == "public" ? 1 : 0
  name                = local.lb_name
  resource_group_name = data.azurerm_resource_group.azlb.name
  location            = coalesce(var.location, data.azurerm_resource_group.azlb.location)
  sku                 = var.lb_sku

  frontend_ip_configuration {
    name                 = var.frontend_name
    public_ip_address_id = join("", azurerm_public_ip.azlb.*.id)
    # private_ip_address            = var.frontend_private_ip_address
    # private_ip_address_allocation = var.frontend_private_ip_address_allocation
  }

  tags = merge(var.additional_tags, {
    source = "terraform"
  })
}

resource "azurerm_lb" "azlb_private" {
  count               = var.type == "public" ? 0 : 1
  name                = local.lb_name
  resource_group_name = data.azurerm_resource_group.azlb.name
  location            = coalesce(var.location, data.azurerm_resource_group.azlb.location)
  sku                 = var.lb_sku

  frontend_ip_configuration {
    name                          = var.frontend_name
    subnet_id                     = var.frontend_subnet_id
    private_ip_address            = var.frontend_private_ip_address
    private_ip_address_allocation = var.frontend_private_ip_address_allocation
  }

  tags = merge(var.additional_tags, {
    source = "terraform"
  })
}

resource "azurerm_lb_backend_address_pool" "azlb" {
  name            = "BackEndAddressPool"
  loadbalancer_id = var.type == "public" ? azurerm_lb.azlb_public.*.id[0] : azurerm_lb.azlb_private.*.id[0]
}

resource "azurerm_lb_nat_rule" "azlb" {
  count                          = length(var.remote_port)
  name                           = "VM-${count.index}"
  resource_group_name            = data.azurerm_resource_group.azlb.name
  loadbalancer_id                = var.type == "public" ? azurerm_lb.azlb_public.*.id[0] : azurerm_lb.azlb_private.*.id[0]
  protocol                       = "Tcp"
  frontend_port                  = "5000${count.index + 1}"
  backend_port                   = element(var.remote_port[element(keys(var.remote_port), count.index)], 1)
  frontend_ip_configuration_name = var.frontend_name
}

resource "azurerm_lb_probe" "azlb" {
  count               = length(var.lb_probe)
  name                = element(keys(var.lb_probe), count.index)
  loadbalancer_id     = var.type == "public" ? azurerm_lb.azlb_public.*.id[0] : azurerm_lb.azlb_private.*.id[0]
  protocol            = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 0)
  port                = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 1)
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
  request_path        = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 2)
}

resource "azurerm_lb_backend_address_pool_address" "azlb" {
  count                   = length(var.emqx_private_ips)
  name                    = "emqx_vm_${count.index}"
  backend_address_pool_id = resource.azurerm_lb_backend_address_pool.azlb.id
  virtual_network_id      = var.vnet_id
  ip_address              = var.emqx_private_ips[count.index]
}

resource "azurerm_lb_rule" "azlb" {
  count                          = length(var.lb_port)
  name                           = element(keys(var.lb_port), count.index)
  loadbalancer_id                = var.type == "public" ? azurerm_lb.azlb_public.*.id[0] : azurerm_lb.azlb_private.*.id[0]
  protocol                       = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  frontend_port                  = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
  backend_port                   = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
  frontend_ip_configuration_name = var.frontend_name
  enable_floating_ip             = false
  disable_outbound_snat          = true
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.azlb.id]
  idle_timeout_in_minutes        = 5
  probe_id                       = element(azurerm_lb_probe.azlb.*.id, count.index)
}

