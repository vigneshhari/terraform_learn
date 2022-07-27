# Variables

variable "main_vpc_cidr" { default = "10.0.0.0/24" }
variable "public_subnet_1" {  default = "10.0.0.128/26" }
variable "public_subnet_2" {  default = "10.0.0.64/26" }
variable "private_subnet_1" { default = "10.0.0.192/26" }
variable "private_subnet_2" { default = "10.0.0.0/26" }

variable "image_uri" {
  type    = string
  default = "nginx:latest"
}
variable "app" {
  type    = string
  default = "nginx"
}
