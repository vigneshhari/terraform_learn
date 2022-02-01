variable "main_vpc_cidr" { default = "10.0.0.0/24" }
variable "public_subnets" { default = "10.0.0.128/26" }
variable "private_subnets" { default = "10.0.0.192/26" }
variable "image_uri" {
  type    = string
  default = "nginx"
}
variable "app" {
  type    = string
  default = "nginx"
}

variable "cluster_id" {
  default = "arn:aws:ecs:ap-southeast-1:632289439953:cluster/test-cluster"
}
