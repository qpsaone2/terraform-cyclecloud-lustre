variable "lustre_name" {
  description = "Managed Lustre 파일 시스템의 이름"
  type        = string
}

variable "sku_name" {
  description = "Lustre의 성능 및 비용을 결정하는 SKU"
  type        = string
}

variable "storage_capacity_tb" {
  description = "Lustre 클러스터의 저장 공간 크기 (TiB)"
  type        = number
}

variable "location" {
  description = "배포할 Azure 지역"
  type        = string
}

variable "rg_name" {
  description = "리소스 그룹 이름"
  type        = string
}

variable "subnet_id" {
  description = "Lustre를 배포할 서브넷의 ID"
  type        = string
}

variable "storage_container_id" {
  description = "Blob 연동을 위한 스토리지 컨테이너의 ID"
  type        = string
}

variable "logging_container_id" {
  description = "Lustre 로그 저장을 위한 스토리지 컨테이너의 ID"
  type        = string
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}

variable "amlfs_maintenance_day_of_week" {
  type        = string
  default     = "Saturday"
  validation {
    condition     = contains(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], var.amlfs_maintenance_day_of_week)
    error_message = "The maintenance day of week value must be one of the following: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday."
  }
  description = "Day of the week on which the maintenance window will occur."
}

variable "amlfs_maintenance_time_of_day" {
  type        = string
  default     = "02:00"
  description = "The time of day (in UTC) to start the maintenance window."
}