resource "azurerm_subnet" "subnet" {
  for_each = var.vnets
  name                 = "subnet-${each.key}"
  resource_group_name  = var.rg_group
  virtual_network_name = each.value.name
  address_prefixes     = ["10.${each.key}.0.0/24"]
}
