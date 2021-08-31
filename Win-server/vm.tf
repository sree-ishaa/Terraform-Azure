resource "azurerm_windows_virtual_machine" "example" {
  name                = "MyTestMachine"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  location            = "eastus"
  size                = "Standard_B2ms"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.myterraformnic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "test" {
    name = "hostname"
    virtual_machine_id = "${azurerm_windows_virtual_machine.example.id}"
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.10"

    settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe mkdir C:\\files; powershell.exe Invoke-WebRequest -Uri https://azureengb03tfstate.blob.core.windows.net/armtemplates/addeploy.ps1 -UseBasicParsing  -O C:\\files\\addeploy.ps1; powershell.exe C:\\files\\addeploy.ps1"
    }
SETTINGS

}
