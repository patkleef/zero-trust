resource "azurerm_private_dns_zone" "private_dns_app_service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_app_service_hub_link" {
  name                  = "private-dns-appservice-link-hub"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_app_service.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  resource_group_name   = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_app_service_spoke_link" {
  name                  = "private-dns-appservice-link-spoke"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_app_service.name
  virtual_network_id    = azurerm_virtual_network.vnet_smartmoney.id
  resource_group_name   = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone" "private_dns_storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_storage_account_hub_link" {
  name                  = "private-dns-storageaccount-link-hub"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_storage_account.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  resource_group_name   = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_storage_account_spoke_link" {
  name                  = "private-dns-storageaccount-link-spoke"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_storage_account.name
  virtual_network_id    = azurerm_virtual_network.vnet_smartmoney.id
  resource_group_name   = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone" "private_dns_sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_sql_hub_link" {
  name                  = "private-dns-sql-link-hub"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_sql.name  
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  resource_group_name   = azurerm_resource_group.rg_hub.name  
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_sql_spoke_link" {
  name                  = "private-dns-sql-link-spoke"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_sql.name  
  virtual_network_id    = azurerm_virtual_network.vnet_smartmoney.id
  resource_group_name   = azurerm_resource_group.rg_hub.name  
}
