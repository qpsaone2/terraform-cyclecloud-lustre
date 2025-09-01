variable "rg_name" { type = string }
variable "location" { type = string }
variable "nsg_name" { type = string }
variable "allowed_public_ips" {
  type    = list(string)
  default = []
}
variable "tags" { type = map(string) }
