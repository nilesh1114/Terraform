provider "aws" {
  region = "us-east-1"
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
  key_name      = "your-ssh-key-name"    # Replace with your SSH key
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
      private_key = file("/Users/your-username/.ssh/your-private-key.pem")  # Path to your private key
      host        = self.public_ip
    }
  }
}
