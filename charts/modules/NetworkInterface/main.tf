resource "azurerm_network_interface" "network_interface" {
  count = 3
  name                = "network-interface-${count.index}"
  location            = var.location
  resource_group_name = var.rg_group

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = var.subnet_ids[count.index < 2 ? 0 : 1]
    private_ip_address_allocation = "Dynamic"
  }
}