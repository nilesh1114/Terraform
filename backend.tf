# backend.tf - Root-level backend configuration

terraform {
  backend "s3" {
    bucket         = "powertool1107"
    region         = "us-east-1"
    encrypt        = true
    versioning     = true
    dynamodb_table = "powertool"
  }
}
