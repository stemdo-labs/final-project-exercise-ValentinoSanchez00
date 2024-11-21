output "network_interface_ids" {
   value = [for k, v in azurerm_network_interface.network_interface : v.id]
  
}
output "ippublics" {
   value = azurerm_public_ip.ippublics
  
}
