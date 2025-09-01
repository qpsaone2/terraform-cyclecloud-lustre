variable "rg_name" { type = string }
variable "location" { type = string }
variable "name" { type = string }
variable "containers" {
  type    = list(string)
  default = []
}
variable "tags" { type = map(string) }
