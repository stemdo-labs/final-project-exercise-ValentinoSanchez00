variable "location" {
  
}
variable "rg_group" {
  
}
variable "network_interface_ids" {
  
}
variable "public_ip" {
  
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