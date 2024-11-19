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
    container_name       = "tfstateblob"            # El nombre del contenedor
    key                  = "terraform.tfstate"  # El nombre del archivo de estado
  } 
}
provider "azurerm" {
  features {}
}
# 2 vnet (machines y cluster) 
module "vnet" {
  source = "./modules/Vnet/"
  location = var.location
  rg_group = var.rg_group
}
# 2 peering para conectar las 2 vnet
module "peering" {
  source = "./modules/Peering/"
  rg_group = var.rg_group
  vnets = module.vnet.vnets
}

#  2 subnets (una para cada vnet)
module "subnet" {
  source = "./modules/Subnet/"
  rg_group = var.rg_group
  vnets = module.vnet.vnets
}
# 3 interfaz de red una por cada subnet y otra para el cluster
module "network-interface" {
  source = "./modules/NetworkInterface/"
  location = var.location
  rg_group = var.rg_group
  subnet_ids = module.subnet.subnet_ids
}
# 2 maquinas virtuales  
module "virtual-machine" {
  source = "./modules/Vmachine/"
  location = var.location
  rg_group = var.rg_group
  network_interface_ids = module.network-interface.network_interface_ids
  
}

# El cluster
module "cluster" {
  source = "./modules/Cluster/"
  location = var.location
  rg_group = var.rg_group
  subnet_ids = module.subnet.subnet_ids
}

# Poner esto en modulo
resource "azurerm_container_registry" "acr" {
  name                = "containerRegistryvsanchezdvfinlab"
  resource_group_name = var.rg_group
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                = "West Europe"
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = "West Europe"
    zone_redundancy_enabled = true
    tags                    = {}
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "tfstateblob"
  storage_account_name  = "stavsanchezdvfinlab"
  
}
