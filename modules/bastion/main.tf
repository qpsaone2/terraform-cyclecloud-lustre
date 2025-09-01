# Bastion Host Public IP 
resource "azurerm_public_ip" "pip" {
  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Azure Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "bastion_id" {
  value = azurerm_bastion_host.bastion.id
}
