# 1. NSG 서브넷 할당 
resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = var.nsg_id
}
