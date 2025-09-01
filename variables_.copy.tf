# variable "location" {
#   type    = string
#   default = "koreacentral"
# }

# variable "rg_name" {
#   type    = string
#   default = "rg-hpc-lab"
# }

# variable "vnet_name" {
#   type    = string
#   default = "vnet-01"
# }

# variable "vnet_address_space" {
#   type    = list(string)
#   default = ["10.0.0.0/16"]
# }

# variable "cidr_bastion" {
#   type    = string
#   default = "10.0.0.0/27"
# }

# variable "cidr_cycle" {
#   type    = string
#   default = "10.0.1.0/24"
# }

# variable "cidr_lustre" {
#   type    = string
#   default = "10.0.2.0/24"
# }

# variable "allowed_public_ips" {
#   description = "Bastion 443 허용 공인 IP 리스트"
#   type        = list(string)
#   default     = []
# }

# variable "cyclecloud_storage_name" {
#   type    = string
#   default = "cyclecloudstg001"
# }

# variable "dataset_storage_name" {
#   type    = string
#   default = "datasetstg001"
# }

# variable "vm_size" {
#   type    = string
#   default = "Standard_D4s_v5"
# }

# variable "admin_username" {
#   type    = string
#   default = "azureuser"
# }

# # ===== CycleCloud Marketplace Image (koreacentral에서 확인된 조합) =====
# variable "cc_img_publisher" {
#   type    = string
#   default = "azurecyclecloud"
# }

# variable "cc_img_offer" {
#   type    = string
#   default = "azure-cyclecloud"
# }

# variable "cc_img_sku" {
#   type    = string
#   default = "cyclecloud8"
# }

# variable "cc_img_version" {
#   type    = string
#   default = "latest"
# }

# variable "cc_plan_name" {
#   type    = string
#   default = "cyclecloud8"
# }

# variable "cc_plan_product" {
#   type    = string
#   default = "azure-cyclecloud"
# }

# variable "cc_plan_publisher" {
#   type    = string
#   default = "azurecyclecloud"
# }

# # ===== SSH 공개키 처리 =====
# variable "ssh_public_key_path" {
#   type    = string
#   default = "~/.ssh/id_rsa.pub"
# }

# variable "ssh_public_key" {
#   type    = string
#   default = ""
# }

# variable "tags" {
#   type = map(string)
#   default = {
#     env   = "lab"
#     owner = "hpc"
#   }
# }
