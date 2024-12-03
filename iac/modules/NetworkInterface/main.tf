# hacemos una ip publica para el cluster para conectarlo al internet
resource "azurerm_public_ip" "ippublics" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = var.rg_group
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "network_interface" {
  count = 2
  name                = "network-interface-${count.index}"
  location            = var.location
  resource_group_name = var.rg_group

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = "/subscriptions/86f76907-b9d5-46fa-a39d-aff8432a1868/resourceGroups/final-project-common/providers/Microsoft.Network/virtualNetworks/vnet-common-bootcamp/subnets/sn-vsanchez"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = count.index == 1 ? azurerm_public_ip.ippublics.id : null
  }
}


