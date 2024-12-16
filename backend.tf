terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"  # Replace with your actual bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1"  # Adjust to your region
    dynamodb_table = "terraform-state-lock"  # Adjust to your DynamoDB table name
    encrypt        = true
  }
}
