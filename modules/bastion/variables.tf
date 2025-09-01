variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "bastion_name" {
  type = string
}

variable "subnet_id" {
  description = "AzureBastionSubnet 의 Subnet ID"
  type        = string
}

variable "tags" {
  type = map(string)
  default = {}
}
