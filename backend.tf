# Configure the backend for Terraform state storage using S3 and DynamoDB for state locking
terraform {
  backend "s3" {
    bucket         = "powertool1107"  # S3 bucket for state storage
    key            = "file/terraform.tfstate"                  # Path for the state file
    region         = "us-east-1"                           # AWS region
    dynamodb_table = "powertool"  # DynamoDB table for state locking
    
attribute {
    name = "LockID"
    type = "S"  # String type for LockID
  }
  }
}
