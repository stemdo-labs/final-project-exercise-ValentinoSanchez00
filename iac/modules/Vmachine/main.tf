resource "azurerm_virtual_machine" "virtual_machine" {
  count = 2
  name                  = "virtual-machine-${count.index}"
  location              = var.location
  resource_group_name   = var.rg_group
  network_interface_ids = [var.network_interface_ids[count.index < 1 ? 0 : 1]]
  vm_size               = "Standard_B1ms"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "mydiskmachine${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  delete_os_disk_on_termination = true

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Solo aplicar el provisioner cuando count.index == 1
  provisioner "remote-exec" {
    when = "create"

    connection {
      type     = "ssh"
      user     = "adminuser"
      password = "Password1234!"
      host     = var.public_ip.ip_address
    }

  }
}
