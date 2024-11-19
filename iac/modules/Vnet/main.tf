# Necesito 2 de esta una mpara las 2 maquinas y otra para el cluster
resource "azurerm_virtual_network" "machines" {
  name                = "virtual-network-machines"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_group
}

resource "azurerm_virtual_network" "cluster" {
  name                = "virtual-network-cluster"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_group
}