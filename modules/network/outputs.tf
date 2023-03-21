output "nic_ids" {
  description = "the id of the network interface"
  value       = [for nic in azurerm_network_interface.nic : nic.id]
}

output "subnet_ids" {
  description = "the ids of all subnet"
  value       = [for sn in azurerm_subnet.sn : sn.id]
}

output "vnet_id" {
  description = "the id of virtual network"
  value       = resource.azurerm_virtual_network.vnet.id

}