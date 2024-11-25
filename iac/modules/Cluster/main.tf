resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "clustervsanchez"
  location            = "eastus"
  resource_group_name = var.rg_group
  dns_prefix          = "cluster" 

  default_node_pool {
    name       = "nodecluster"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id      = var.subnet_ids[1]
  }
  identity {
    type = "SystemAssigned"
  }
}
