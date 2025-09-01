# 1.Lustre 서비스 주체(Service Principal) 정보를 조회합니다.
data "azuread_service_principal" "hpc_cache" {
  display_name = "HPC Cache Resource Provider"
}

# 2.'Storage Blob 데이터 기여자' 역할 할당
resource "azurerm_role_assignment" "lustre_storage_blob_data_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_service_principal.hpc_cache.id
}

# 3.'기여자(Contributor)' 역할 할당
resource "azurerm_role_assignment" "lustre_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.hpc_cache.id
}