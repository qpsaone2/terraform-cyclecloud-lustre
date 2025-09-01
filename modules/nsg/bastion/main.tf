# NSG 생성 
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

# ─────────────────────────────
# Inbound 
# ─────────────────────────────

# 59.10.176.51 만 443 허용
resource "azurerm_network_security_rule" "in_allow_office_443" {
  name                        = "AllowOffice"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = ["59.10.176.51/32"]
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# GatewayManager 443 허용
resource "azurerm_network_security_rule" "in_allow_gatewaymanager_443" {
  name                        = "AllowGatewayManager"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# AzureLoadBalancer 모든 포트 허용
resource "azurerm_network_security_rule" "in_allow_azlb_all" {
  name                        = "AllowLoadBalancer"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Bastion 내부 통신 8080, 5701 허용 (VNet ↔ VNet)
resource "azurerm_network_security_rule" "in_allow_bastionhost" {
  name                        = "AllowBastionHost"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "5701"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# 커스텀 인바운드 전면 차단
resource "azurerm_network_security_rule" "in_deny_any_custom" {
  name                        = "DenyAnyCustomInbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# ─────────────────────────────
# Outbound 
# ─────────────────────────────

# VNet으로 22,3389 허용
resource "azurerm_network_security_rule" "out_allow_ssh_rdp" {
  name                        = "AllowSshRdpOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389"]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# AzureCloud 443 허용
resource "azurerm_network_security_rule" "out_allow_azurecloud_443" {
  name                        = "AzureCloud"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Bastion 내부 통신 8080, 5701 허용 (VNet)
resource "azurerm_network_security_rule" "out_allow_bastion_comm" {
  name                        = "AllowBastionCommunication"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "5701"]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# 인터넷 80 허용
resource "azurerm_network_security_rule" "out_allow_any_custom_80" {
  name                        = "AllowAnyCustomOutbound"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}
