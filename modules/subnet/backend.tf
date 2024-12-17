# backend.tf - Separate Backend Configuration for Security Group Module

terraform {
  backend "s3" {
    bucket         = "powertool1107"
    key            = "security_group/terraform.tfstate"  # State file specific to the security_group module
    region         = "us-east-1"
    encrypt        = true
    versioning     = true
    dynamodb_table = "powertool"
  }
}
