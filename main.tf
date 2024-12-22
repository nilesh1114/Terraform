# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Define the security group
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow inbound web traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.allow_web.name]

  # Configure Ansible as a provisioner
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    # Connect to the instance using SSH
    connection {
      type        = "ssh"
      user        = "ubuntu"  # For Ubuntu instances
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "WebServer"
  }
}

# Output the public IP of the EC2 instance
output "instance_ip" {
  value = aws_instance.web.public_ip
}
