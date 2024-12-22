provider "aws" {
  region = "us-east-1"
}

# Step 1: Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "example_secret" {
  name        = "my-database-secret"
  description = "A secret for my database password"
}

resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id     = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    db_password = "my-secret-password-123"
  })
}

# Step 2: Retrieve the secret using data source
data "aws_secretsmanager_secret" "example" {
  secret_id = aws_secretsmanager_secret.example_secret.id
}

data "aws_secretsmanager_secret_version" "example_version" {
  secret_id = data.aws_secretsmanager_secret.example.id
}

# Step 3: Output the secret value (marked as sensitive to avoid plaintext output)
output "db_password" {
  value     = data.aws_secretsmanager_secret_version.example_version.secret_string["db_password"]
  sensitive = true
}

# Step 4: Launch an EC2 instance and use the secret value (e.g., for authentication)
resource "aws_instance" "example_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your region's AMI
  instance_type = "t2.micro"

  # Use the secret password for an environment variable or initialization
  user_data = <<-EOF
              #!/bin/bash
              echo "DB_PASSWORD=${data.aws_secretsmanager_secret_version.example_version.secret_string["db_password"]}" > /etc/db_password.txt
              EOF

  tags = {
    Name = "ExampleEC2"
  }
}
