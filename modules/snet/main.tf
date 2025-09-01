# 1. 서브넷 생성 
resource "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.address_prefix]
}

output "subnet_id" { value = azurerm_subnet.snet.id }
