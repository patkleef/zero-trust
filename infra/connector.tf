# joins Azure AD device: https://support.microsoft.com/en-us/account-billing/join-your-work-device-to-your-work-or-school-network-ef4d6adb-5095-4e51-829e-5457430f3973

// https://learn.microsoft.com/en-us/azure/active-directory/app-proxy/application-proxy-add-on-premises-application
resource "azurerm_network_interface" "nic_connector" {
  count               = local.deploy_app_proxy ? 1 : 0

  name                = "nic-connector"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_connector.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_connector[0].id 
  }
}

resource "azurerm_public_ip" "public_ip_connector" {
  count               = local.deploy_app_proxy ? 1 : 0

  name                = "pip-connector"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  allocation_method   = "Dynamic"
}

resource "azurerm_windows_virtual_machine" "vm_windows_connector" {
  count               = local.deploy_app_proxy ? 1 : 0

  name                = "vm-connector"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = azurerm_resource_group.rg_hub.location
  size                = "Standard_B2s"
  admin_username      = "asdf"
  admin_password      = "sdfsfdsfd"
  network_interface_ids = [
    azurerm_network_interface.nic_connector[0].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# Configurations on the VM
# Windows Registry Editor Version 5.00

# [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2]
# [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client]
# "DisabledByDefault"=dword:00000000
# "Enabled"=dword:00000001
# [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server]
# "DisabledByDefault"=dword:00000000
# "Enabled"=dword:00000001
# [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319]
# "SchUseStrongCrypto"=dword:00000001

# 2. Enable Javascript in IE -> start IE -> settings -> security -> custom level -> active scripting: true

# 3. Download connector from portal.azure.com (app proxy) -> install connector on VM. Login with global admin -> create local user

# also option to use this TF module: https://github.com/shibayan/terraform-azurerm-appservice-proxy/tree/master