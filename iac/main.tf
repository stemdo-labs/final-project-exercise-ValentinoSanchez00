terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.5.0"
    }
  }
   backend "azurerm" {
    resource_group_name  = "rg-vsanchez-dvfinlab" # El nombre del resource group que definiste
    storage_account_name = "stavsanchezdvfinlab"   # El nombre del Storage Account
    container_name       = "tfstatecont"            # El nombre del contenedor
    key                  = "terraform.tfstate"  # El nombre del archivo de estado
  }  
 
}
provider "azurerm" {
  features {}
}
# 2 vnet (machines y cluster) 

module "network-interface" {
  source = "./modules/NetworkInterface/"
  location = var.location
  rg_group = var.rg_group
}
# 2 maquinas virtuales  
module "virtual-machine" {
  source = "./modules/Vmachine/"
  location = var.location
  rg_group = var.rg_group
  network_interface_ids = module.network-interface.network_interface_ids
  public_ip = module.network-interface.ippublics
  
}


# Poner esto en modulo
resource "azurerm_container_registry" "acr" {
  name                = "containerregistrvsanchez"
  resource_group_name = var.rg_group
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}
resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_name  = "stavsanchezdvfinlab"
  
}
resource "azurerm_network_security_group" "securitygroup" {
  name                = "securitygroup"
  location            = var.location
  resource_group_name = var.rg_group

  security_rule {
    name                       = "securityRule1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
resource "azurerm_subnet_network_security_group_association" "assosiaton" {
  subnet_id                 = "/subscriptions/86f76907-b9d5-46fa-a39d-aff8432a1868/resourceGroups/final-project-common/providers/Microsoft.Network/virtualNetworks/vnet-common-bootcamp/subnets/sn-vsanchez"
  network_security_group_id = azurerm_network_security_group.securitygroup.id
}

