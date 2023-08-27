resource "azurerm_storage_account" "smartmoney_storage_account" {
  name                     = "stsmartmoney"
  resource_group_name      = azurerm_resource_group.rg_smartmoney.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "smartmoney_storage_account_private_endpoint" {
  name                = "pep-smartmoney-storage-account"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  subnet_id           = azurerm_subnet.subnet_private_endpoint.id

  private_dns_zone_group {
    name                 = "smartmoney-storage-account-private-endpoint-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_storage_account.id]
  }
  private_service_connection {
    name                           = "pep-smartmoney-storage-account"
    private_connection_resource_id = azurerm_storage_account.smartmoney_storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
