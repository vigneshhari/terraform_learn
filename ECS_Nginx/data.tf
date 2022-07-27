# Availiability zone config
data "aws_availability_zones" "available" {
  state = "available"
}
