# Provider configuration
provider "aws" {
  region = "us-east-1"  
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
  availability_zone       = "us-east-1a"  
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

# Create an S3 bucket to store Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "powertool1407"  # Replace with a globally unique name
  acl    = "private"
 
versioning {
    enabled = true  # Optional: Enable versioning for S3 objects
  }

  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion of the bucket
  }
  
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "powertool1"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion of the bucket
  }
}




