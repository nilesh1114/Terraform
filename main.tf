provider "aws" {
  region = "us-east-1"
}

# Create SSH key pair
resource "aws_key_pair" "web_key" {
  key_name   = "web-key"
  public_key = file("${path.module}/your-public-key.pub")
}

# Security group to allow HTTP (port 80) and SSH (port 22) traffic
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

# Provision an EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  key_name      = aws_key_pair.web_key.key_name
  security_groups = [aws_security_group.web_sg.name]
  tags = {
    Name = "WebServer"
  }

  # Use remote-exec to configure EC2 with Ansible
  provisioner "remote-exec" {
    inline = [
      "echo 'Provisioning started!'"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/ssh_keys/private-key.pem")
      host        = self.public_ip
    }
  }
}

# Outputs the private key
output "private_key" {
  value = aws_key_pair.web_key.private_key
  sensitive = true
}
