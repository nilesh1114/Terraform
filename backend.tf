# backend.tf - Root-level backend configuration

terraform {
  backend "s3" {
    bucket         = "powertool1107"
    key            = "lab4/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "powertool"
  }
}
