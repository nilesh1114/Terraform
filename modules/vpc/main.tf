provider "aws" {
  region = var.region
}

resource "aws_vpc" "mbrapp" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.mbrapp.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mbrapp.id
}

resource "aws_route" "internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mbrapp.id
}

resource "aws_internet_gateway" "mbrapp" {
  vpc_id = aws_vpc.mbrapp.id
}
