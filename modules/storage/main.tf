# 1. 스토리지 계정 생성 
resource "azurerm_storage_account" "stg" {
  name                      = var.name
  resource_group_name       = var.rg_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  shared_access_key_enabled = true
  tags                      = var.tags
}

# 2. 스토리지 계정 Blob 컨테이너 생성
resource "azurerm_storage_container" "ct" {
  for_each              = toset(var.containers)
  name                  = each.value
  # storage_account_name  = azurerm_storage_account.stg.name  # ← azurerm versio : 3.x
  storage_account_id    = azurerm_storage_account.stg.id   # ← azurerm versio : 4.x
  container_access_type = "private"
}

