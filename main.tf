

module "vpc" {
  source      = "./modules/vpc"
  vpc_name    = "my-vpc"
  cidr_block  = "10.0.0.0/16"
}

module "security_group" {
  source                = "./modules/security_group"
  security_group_name   = "web-server-sg"
  vpc_id                = module.vpc.vpc_id
  ingress_from_port     = 22
  ingress_to_port       = 22
  ingress_protocol      = "tcp"
  ingress_cidr_blocks   = ["0.0.0.0/0"]
  egress_from_port      = 0
  egress_to_port        = 0
  egress_protocol       = "-1"
  egress_cidr_blocks    = ["0.0.0.0/0"]
}

module "subnet" {
  source               = "./modules/subnet"
  vpc_id               = module.vpc.vpc_id
  cidr_block           = "10.0.1.0/24"
  availability_zone    = "us-east-1a"
  subnet_name          = "web-subnet"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "subnet_id" {
  value = module.subnet.subnet_id
}
