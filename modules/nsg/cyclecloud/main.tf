# 1. NSG 생성
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

# ─────────────────────────────
# Inbound (인바운드 규칙)
# ─────────────────────────────

# 2. Bastion 서브넷에서 오는 SSH(22) 트래픽 허용
resource "azurerm_network_security_rule" "allow_ssh_from_bastion" {
  name                        = "Allow-SSH-From-Bastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.bastion_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# 3. 지정된 공인 IP 목록에서 오는 HTTPS(443) 트래픽 허용
resource "azurerm_network_security_rule" "allow_https_from_myip" {
  name                        = "Allow-HTTPS-From-MyIP"
  priority                    = 110 
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443" 
  source_address_prefixes     = var.allowed_public_ips  
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# 4. 지정된 공인 IP 목록에서 오는 HTTP(80) 트래픽 허용 (HTTPS 리디렉션용)
resource "azurerm_network_security_rule" "allow_http_from_myip" {
  name                        = "Allow-HTTP-From-MyIP"
  priority                    = 120 
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80" 
  source_address_prefixes     = var.allowed_public_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

output "nsg_id" { value = azurerm_network_security_group.nsg.id }
