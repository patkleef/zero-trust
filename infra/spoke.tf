resource "azurerm_resource_group" "rg_smartmoney" {
  name     = "rg-smartmoney"
  location = local.location
}

# subnet calculator: https://www.davidc.net/sites/default/subnets/subnets.html?network=10.1.0.0&mask=16&division=11.f40
resource "azurerm_virtual_network" "vnet_smartmoney" {
  name                = "vnet-smartmoney"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_smartmoney.location
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
}

resource "azurerm_subnet" "subnet_frontend" {
  name                 = "snet-frontend"
  resource_group_name  = azurerm_resource_group.rg_smartmoney.name
  virtual_network_name = azurerm_virtual_network.vnet_smartmoney.name
  address_prefixes     = ["10.1.0.0/20"]
}

resource "azurerm_subnet" "subnet_backend" {
  name                 = "snet-backend"
  resource_group_name  = azurerm_resource_group.rg_smartmoney.name
  virtual_network_name = azurerm_virtual_network.vnet_smartmoney.name
  address_prefixes     = ["10.1.16.0/20"]
}

resource "azurerm_subnet" "subnet_private_endpoint" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.rg_smartmoney.name
  virtual_network_name = azurerm_virtual_network.vnet_smartmoney.name
  address_prefixes     = ["10.1.32.0/20"]
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "smartmoney-to-hub"
  resource_group_name          = azurerm_resource_group.rg_smartmoney.name
  virtual_network_name         = azurerm_virtual_network.vnet_smartmoney.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}