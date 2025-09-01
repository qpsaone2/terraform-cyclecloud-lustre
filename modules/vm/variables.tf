variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

# ===== CycleCloud Marketplace Image =====
variable "cc_img_publisher" {
  type    = string
  default = "azurecyclecloud"
}

variable "cc_img_offer" {
  type    = string
  default = "azure-cyclecloud"
}

variable "cc_img_sku" {
  type    = string
  default = "cyclecloud8"
}

variable "cc_img_version" {
  type    = string
  default = "latest"
}

# ===== CycleCloud Plan (이미지와 반드시 동일) =====
variable "cc_plan_name" {
  type    = string
  default = "cyclecloud8"
}

variable "cc_plan_product" {
  type    = string
  default = "azure-cyclecloud"
}

variable "cc_plan_publisher" {
  type    = string
  default = "azurecyclecloud"
}

variable "tags" {
  type = map(string)
}

variable "data_disk_size_gb" {
  description = "Data disk size in GiB for the CycleCloud VM"
  type        = number
  default     = 512 # 기본값 512GB
}