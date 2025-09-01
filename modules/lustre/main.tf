# Managed Lustre 생성 
resource "azurerm_managed_lustre_file_system" "amlfs" {
  name                   = var.lustre_name
  location               = var.location
  resource_group_name    = var.rg_name
  sku_name               = var.sku_name
  storage_capacity_in_tb = var.storage_capacity_tb
  subnet_id              = var.subnet_id
  zones = ["1"] 
  
  # Lustre 생성 타임아웃
  timeouts {
    create = "3h"
    delete = "2h"
  }


  # 스토리지(Blob) 연동 설정
  hsm_setting {
    container_id  = var.storage_container_id
    logging_container_id = var.logging_container_id
    import_prefix = "/" # 컨테이너의 모든 데이터를 가져옵니다.
  }
  
  # Lustre 유지관리 
  maintenance_window {
    day_of_week = var.amlfs_maintenance_day_of_week
    time_of_day_in_utc = var.amlfs_maintenance_time_of_day
  }
  tags = var.tags
}