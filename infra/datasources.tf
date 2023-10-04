data "azurerm_client_config" "current" {
}

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

data "azuread_service_principal" "smartmoney_app_proxy" {
  display_name = "SmartMoneyApplication"
}