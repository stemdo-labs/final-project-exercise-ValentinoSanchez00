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

}


resource "azurerm_virtual_machine_extension" "custom_script" {
  name                 = "script-runner"
  virtual_machine_id   = azurerm_virtual_machine.virtual_machine[1].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        # Crear una carpeta para el runner y entrar en ella
        mkdir actions-runner
        cd actions-runner

        # Descargar el paquete del runner más reciente
        Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-win-x64-2.320.0.zip -OutFile actions-runner-win-x64-2.320.0.zip

        # (Opcional) Validar el hash
        if ((Get-FileHash -Path actions-runner-win-x64-2.320.0.zip -Algorithm SHA256).Hash.ToUpper() -ne '9eb133e8cb25e8319f1cbef3578c9ec5428a7af7c6ec0202ba6f9a9fddf663c0'.ToUpper()) { 
            throw 'Computed checksum did not match' 
        }

        # Extraer el instalador
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.320.0.zip", "$PWD")

        # Definir el token como variable

        # Configurar el runner de forma automatizada (sin interacción)
        ./config.cmd --url https://github.com/stemdo-labs/final-project-exercise-ValentinoSanchez00 --token ${{ secrets.RUNNER_TOKEN }} --name "runner-name" --work "_work" --replace

        # Ejecutar el runner automáticamente
        ./run.cmd --once

    }
  SETTINGS
}