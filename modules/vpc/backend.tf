# backend.tf - Separate Backend Configuration for VPC Module

terraform {
  backend "s3" {
    bucket         = "powertool1107"
    key            = "vpc/terraform.tfstate"  # State file specific to the vpc module
    region         = "us-east-1"
    encrypt        = true
    versioning     = true
    dynamodb_table = "powertool"
  }
}
