variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "cluster_name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "aws_region" {
  default = "us-west-2"
  type    = string
}


provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_db_instance" "default" {
  identifier             = var.identifier
  allocated_storage      = var.storage
  engine                 = var.engine
  engine_version         = lookup(var.engine_version, var.engine)
  instance_class         = var.instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  db_subnet_group_name   = aws_db_subnet_group.default.id
  skip_final_snapshot       = true

  final_snapshot_identifier = "last-${var.identifier}-snapshot"
  depends_on             = [aws_security_group.default]
}

resource "aws_db_subnet_group" "default" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = aws_subnet.subnet[*].id
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = map("Name", "rds-demo")
}

data "aws_availability_zones" "available" {}
