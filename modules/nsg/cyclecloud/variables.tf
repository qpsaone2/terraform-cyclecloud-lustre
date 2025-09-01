variable "rg_name" { type = string }
variable "location" { type = string }
variable "nsg_name" { type = string }
variable "bastion_cidr" { type = string }
variable "tags" { type = map(string) }
variable "allowed_public_ips" {
  description = "NSG에서 허용할 공인 IP 주소 목록"
  type        = list(string)
  default     = []
}