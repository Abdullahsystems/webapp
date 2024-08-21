resource "azurerm_resource_group" "rsg" {
    name = "rsg"
    location = "northeurope"
  
}
resource "azurerm_virtual_network" "VNET1" {
    address_space = ["10.0.0.0/16"]
    location = "northeurope"
    name = "Vnet1"
    resource_group_name = azurerm_resource_group.rsg.name
    depends_on = [ azurerm_resource_group.rsg ] 
}
resource "azurerm_subnet" "subnet1" {
    name = "subnet1"
    resource_group_name = azurerm_resource_group.rsg.name
    virtual_network_name = azurerm_virtual_network.VNET1.name
    address_prefixes = ["10.0.0.0/24"] 
    depends_on = [ azurerm_virtual_network.VNET1 ]
}
resource "azurerm_network_security_group" "NSG_for_lb_machines" {
  name = "NSG_for_lb_machines"
  resource_group_name = azurerm_resource_group.rsg.name
  location = "northeurope"
  depends_on = [ azurerm_resource_group.rsg ]
}
resource "azurerm_network_interface" "NIC11" {
  name                = "NIC11"
  location            = "northeurope"
  resource_group_name = azurerm_resource_group.rsg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "VM1" {
  name                = "VM1"
  resource_group_name = azurerm_resource_group.rsg.name
  location            = "northeurope"
  size                = "Standard_D2as_v4"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.NIC11.id,
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
resource "azurerm_network_interface_security_group_association" "vmasnsg" {
  network_interface_id      = azurerm_network_interface.NIC11.id
  network_security_group_id = azurerm_network_security_group.NSG_for_lb_machines.id
  depends_on = [azurerm_network_security_group.NSG_for_lb_machines,azurerm_network_interface.NIC22 ]
}
