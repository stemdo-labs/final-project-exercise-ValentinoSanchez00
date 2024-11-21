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

   provisioner "remote-exec" {
    when = count.index == 1 ? "create" : "ignore"

    connection {
      type     = "ssh"
      user     = "adminuser"
      password = "Password1234!"
      host     = azurerm_network_interface.network_interface[count.index].private_ip_address
    }

    inline = [
    "mkdir actions-runner; cd actions-runner",
    "Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-win-x64-2.320.0.zip -OutFile actions-runner-win-x64-2.320.0.zip",
    "Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory(\\\"$PWD/actions-runner-win-x64-2.320.0.zip\\\", \\\"$PWD\\\")",
    "./config.cmd --url https://github.com/stemdo-labs/final-project-exercise-ValentinoSanchez00 --token BDQATEL2BF4XX52QFXPDX5THH4NH2",
    "./run.cmd"
  ]
  }

}


