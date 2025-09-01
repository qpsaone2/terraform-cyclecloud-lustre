output "storage_account_id" {
  description = "생성된 스토리지 계정의 ID"
  value       = azurerm_storage_account.stg.id
}

output "container_ids" {
  description = "생성된 컨테이너들의 ID 맵"
  value       = { for c in azurerm_storage_container.ct : c.name => c.id }
}

output "primary_blob_endpoint" {
  description = "스토리지 계정의 Primary Blob Endpoint 주소"
  value       = azurerm_storage_account.stg.primary_blob_endpoint
}

