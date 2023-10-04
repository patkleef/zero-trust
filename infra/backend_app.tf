resource "azurerm_service_plan" "asp_backend" {
  count               = local.deploy_backend_app ? 1 : 0
  name                = "asp-backend-app"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app_backend" {
  count                         = local.deploy_backend_app ? 1 : 0
  name                          = "app-smartmoney-backend-app"
  resource_group_name           = azurerm_resource_group.rg_smartmoney.name
  location                      = local.location
  service_plan_id               = azurerm_service_plan.asp_backend[0].id
  public_network_access_enabled = false

  site_config {
    always_on = false

    application_stack {
      dotnet_version = "7.0"
    }
  }
}

resource "azurerm_private_endpoint" "backend_private_endpoint" {
  count = local.deploy_backend_app && local.enable_backend_app_private_endpoint ? 1 : 0

  name                = "pv-smartmoney-backend-app"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  subnet_id           = azurerm_subnet.subnet_private_endpoint.id

  private_dns_zone_group {
    name                 = "app-smartmoney-backend-app-private-endpoint-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_app_service.id]
  }

  private_service_connection {
    name                           = "pv-smartmoney-backend-app"
    private_connection_resource_id = azurerm_linux_web_app.app_backend[0].id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
