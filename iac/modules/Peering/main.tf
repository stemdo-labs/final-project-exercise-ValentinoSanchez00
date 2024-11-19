resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = var.rg_group
  virtual_network_name      = var.vnets[0].name
  remote_virtual_network_id = var.vnets[1].id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer1to2"
  resource_group_name       = var.rg_group
  virtual_network_name      = var.vnets[1].name
  remote_virtual_network_id = var.vnets[0].id
}