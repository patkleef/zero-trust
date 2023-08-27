resource "azurerm_mssql_server" "smartmoney_sql" {
  name                         = "sql-smartmoney"
  resource_group_name          = azurerm_resource_group.rg_smartmoney.name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "dbadmin"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "smartmoney_sql_private_endpoint" {
  name                = "pep-smartmoney-sql"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  subnet_id           = azurerm_subnet.subnet_private_endpoint.id

  private_dns_zone_group {
    name                 = "smartmoney-sql-private-endpoint-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_sql.id]
  }
  private_service_connection {
    name                           = "pep-smartmoney-sql"
    private_connection_resource_id = azurerm_mssql_server.smartmoney_sql.id
    is_manual_connection           = false
    subresource_names              = ["SqlServer"]
  }
}