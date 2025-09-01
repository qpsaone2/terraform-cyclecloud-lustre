# 1. 가상네트워크 생성 
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

output "vnet_name" { value = azurerm_virtual_network.vnet.name }
output "vnet_id"   { value = azurerm_virtual_network.vnet.id }
