
resource "azurerm_resource_group" "rg_hub" {
  name     = "rg-hub"
  location = local.location
}

# subnet calculator: https://www.davidc.net/sites/default/subnets/subnets.html?network=10.0.0.0&mask=16&division=9.f00
resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_subnet" "subnet_connector" {
  name                 = "snet-connector"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.0.0.0/20"]
}

resource "azurerm_subnet" "subnet_containers_test" {
  name                 = "snet-containers"
  resource_group_name  = azurerm_resource_group.rg_hub.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.0.16.0/20"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "acidelegationservice"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}
