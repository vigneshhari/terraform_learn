terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "sa-dev"
  region  = "ap-southeast-1"
}



resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow Http/Https inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "app_server" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.publicsubnet_1.id
  tags = {
    Name = "ExampleAppServerInstance"
  }
}