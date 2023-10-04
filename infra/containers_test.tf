resource "azurerm_container_group" "cg_hub_network-multitool" {
  count               = local.deploy_network_multitool ? 1 : 0
  name                = "ci-network-tool-hub"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  subnet_ids          = [ azurerm_subnet.subnet_containers_test.id ]

  container {
    name   = "network-multitool"
    image  = "wbitt/network-multitool"
    cpu    = "1"
    memory = "0.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}

# az container exec --resource-group rg-hub --name ci-network-tool-hub --exec-command "/bin/bash"
# 
