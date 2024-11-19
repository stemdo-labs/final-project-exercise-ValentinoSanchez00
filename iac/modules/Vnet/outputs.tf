output "vnets" {
  value = {
    0 = azurerm_virtual_network.machines
    1  = azurerm_virtual_network.cluster
  }
}