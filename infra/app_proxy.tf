resource "azuread_group" "smartmoney_support_group" {
  display_name     = "SmartMoney-Support"
  types            = ["DynamicMembership"]
  security_enabled = true

  dynamic_membership {
    enabled = true
    rule    = <<-EOR
    (user.department eq "Customer Support")
EOR
  }
}

resource "azuread_app_role_assignment" "smartmoney_app_group_assignment" {
  count = local.deploy_app_proxy ? 1 : 0

  app_role_id         = "00000000-0000-0000-0000-000000000000" # Default access
  principal_object_id = azuread_group.smartmoney_support_group.object_id
  resource_object_id  = data.azuread_service_principal.smartmoney_app_proxy.object_id
}
