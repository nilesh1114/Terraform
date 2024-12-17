# Configure the backend for Terraform state storage using S3 and DynamoDB for state locking
terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.terraform_state.bucket  # S3 bucket for state storage
    key            = "file/terraform.tfstate"                  # Path for the state file
    region         = "us-east-1"                           # AWS region
    dynamodb_table = aws_dynamodb_table.terraform_lock.name # DynamoDB table for state locking
    encrypt        = true                                  # Enable encryption for state files
  }
}
