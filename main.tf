provider "aws" {
  region = "us-east-1"
}

# Step 1: Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "example_secret" {
  name        = "my-database-secret"
  description = "A secret for my database password"
}

# Step 2: Store the secret value (e.g., db password) in the Secrets Manager
resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id     = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    db_password = "my-secret-password-123"
  })

  # Explicitly depend on the secret creation
  depends_on = [aws_secretsmanager_secret.example_secret]
}

# Step 3: Retrieve the secret version using a data source
data "aws_secretsmanager_secret_version" "example_version" {
  secret_id = aws_secretsmanager_secret.example_secret.id

  # Ensure this data source waits until the secret version is available
  depends_on = [aws_secretsmanager_secret_version.example_secret_version]
}

# Step 4: Output the secret value (marked as sensitive)
output "db_password" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example_version.secret_string)["db_password"]
  sensitive = true
}

# Step 5: Launch an EC2 instance and use the secret value (e.g., for authentication)
resource "aws_instance" "example_ec2" {
  ami           = "ami-01816d07b1128cd2d"  # Replace with your region's AMI
  instance_type = "t2.micro"

  # Use the secret password for an environment variable or initialization
  user_data = <<-EOF
              #!/bin/bash
              echo "DB_PASSWORD=${jsondecode(data.aws_secretsmanager_secret_version.example_version.secret_string)["db_password"]}" > /etc/db_password.txt
              EOF

  tags = {
    Name = "ExampleEC2"
  }
}
