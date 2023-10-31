### HUB ###

resource "azurerm_network_security_group" "snet_connector_nsg" {
  name                = "nsg-connector"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_network_security_rule" "allow_connector_traffic" {
  name                        = "allow-connector-traffic"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_hub.name
  network_security_group_name = azurerm_network_security_group.snet_connector_nsg.name
}

resource "azurerm_network_security_rule" "allow_rdp_traffic" {
  name                        = "allow-rdp-traffic"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["3389"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_hub.name
  network_security_group_name = azurerm_network_security_group.snet_connector_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "snet_connector_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_connector.id
  network_security_group_id = azurerm_network_security_group.snet_connector_nsg.id
}

## SPOKE ###

resource "azurerm_network_security_group" "snet_frontend_nsg" {
  name                = "nsg-frontend"
  location            = azurerm_resource_group.rg_smartmoney.location
  resource_group_name = azurerm_resource_group.rg_smartmoney.name

  # deny all other traffic
  security_rule {
    name                       = "inbound-deny-all"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "snet_frontend_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_frontend.id
  network_security_group_id = azurerm_network_security_group.snet_frontend_nsg.id
}

resource "azurerm_network_security_group" "snet_backend_nsg" {
  name                = "nsg-backend"
  location            = azurerm_resource_group.rg_smartmoney.location
  resource_group_name = azurerm_resource_group.rg_smartmoney.name

  security_rule {
    name                       = "allow-frontend-433"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "433"
    source_address_prefixes    = azurerm_subnet.subnet_frontend.address_prefixes
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "inbound-deny-all"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "snet_backend_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_backend.id
  network_security_group_id = azurerm_network_security_group.snet_backend_nsg.id
}

resource "azurerm_network_security_group" "private_endpoint_nsg" {
  name                = "nsg-private-endpoint"
  location            = azurerm_resource_group.rg_smartmoney.location
  resource_group_name = azurerm_resource_group.rg_smartmoney.name

  security_rule {
    name                       = "allow-backend-1433"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefixes    = azurerm_subnet.subnet_backend.address_prefixes
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow-backend-433"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "433"
    source_address_prefixes    = azurerm_subnet.subnet_backend.address_prefixes
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "inbound-deny-all"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "private_endpoint_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet_private_endpoint.id
  network_security_group_id = azurerm_network_security_group.private_endpoint_nsg.id
}
