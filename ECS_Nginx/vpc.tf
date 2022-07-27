# VPC
resource "aws_vpc" "Main" {                
  cidr_block           = var.main_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform VPC"
  }
}

# Internet gateway

resource "aws_internet_gateway" "IGW" { 
  vpc_id = aws_vpc.Main.id              
}

# Subnets

resource "aws_subnet" "publicsubnet_1" { # Creating Public Subnets
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.public_subnet_1
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_subnet" "privatesubnet_1" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.private_subnet_1
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "publicsubnet_2" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.public_subnet_2
  availability_zone = data.aws_availability_zones.available.names[1]
}
resource "aws_subnet" "privatesubnet_2" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.private_subnet_2
  availability_zone = data.aws_availability_zones.available.names[1]
}

# Route Tables

resource "aws_route_table" "PublicRT" { # Creating RT for Public Subnet
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}
resource "aws_route_table" "PrivateRT" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
}
resource "aws_route_table_association" "PublicRTassociation_1" {
  subnet_id      = aws_subnet.publicsubnet_1.id
  route_table_id = aws_route_table.PublicRT.id
}
resource "aws_route_table_association" "PublicRTassociation_2" {
  subnet_id      = aws_subnet.publicsubnet_2.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PrivateRTassociation_1" {
  subnet_id      = aws_subnet.privatesubnet_1.id
  route_table_id = aws_route_table.PrivateRT.id
}
resource "aws_route_table_association" "PrivateRTassociation_2" {
  subnet_id      = aws_subnet.privatesubnet_2.id
  route_table_id = aws_route_table.PrivateRT.id
}

# NAT's

resource "aws_eip" "nateIP_1" {
  vpc = true
}

resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP_1.id
  subnet_id     = aws_subnet.publicsubnet_1.id
}