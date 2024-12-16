# Provider configuration
provider "aws" {
  region = "us-east-1"  # You can change the region as needed
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create subnet in the VPC
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Change this based on your availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
  }
}

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-route-table"
  }
}

# Create a route table association
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create an S3 bucket for Terraform state storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"  # Ensure this is globally unique
  acl    = "private"

  tags = {
    Name = "terraform-state"
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-state-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock"
  }
}

# Configure backend for Terraform state using S3 and DynamoDB for state locking
terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "terraform.tfstate"
    region         = "us-east-1"  # Same region as VPC
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
    encrypt        = true
  }
}
