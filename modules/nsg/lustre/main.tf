# resource "azurerm_network_security_group" "nsg" {
#   name                = var.nsg_name
#   location            = var.location
#   resource_group_name = var.rg_name
#   tags                = var.tags
# }

# resource "azurerm_network_security_rule" "deny_all" {
#   name                        = "Deny-All-Inbound"
#   priority                    = 4096
#   direction                   = "Inbound"
#   access                      = "Deny"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.rg_name
#   network_security_group_name = azurerm_network_security_group.nsg.name
# }

# output "nsg_id" { value = azurerm_network_security_group.nsg.id }
