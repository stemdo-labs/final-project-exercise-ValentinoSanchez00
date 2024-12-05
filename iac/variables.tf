

variable "rg_group" {
  description = "name of the resource group"
  type = string
}

variable "address_space" {
  description = "address space of the vnet"
  type = list(string)
}

variable "location" {
  description = "value of the location"
  type = string
  default = "UK South"
}
variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  sensitive = true

}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive = true
}