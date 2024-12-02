resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = var.rg_group
  virtual_network_name      = var.vnets[0].name
  remote_virtual_network_id = "/subscriptions/86f76907-b9d5-46fa-a39d-aff8432a1868/resourceGroups/final-project-common/providers/Microsoft.Network/virtualNetworks/vnet-common-bootcamp"
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer1to2"
  resource_group_name       = var.rg_group
  virtual_network_name      = "vnet-common-bootcamp"
  remote_virtual_network_id = var.vnets[0].id
}