output "network_interface_ids" {
   value = [for k, v in azurerm_network_interface.network_interface : v.id]
  
}
