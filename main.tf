provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"
  vpc_id      = var.vpc_id

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

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.allow_http.name]
  subnet_id     = var.subnet_id

  tags = {
    Name = "Terraform-WebServer"
  }

  # Use remote-exec to run an Ansible playbook
  provisioner "remote-exec" {
    inline = [
      "echo '${var.ansible_inventory}' > /tmp/ansible_inventory.ini",
      "ansible-playbook -i /tmp/ansible_inventory.ini /tmp/setup_nginx.yml"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = self.public_ip
    }
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}

# Variables file
variable "aws_region" {}
variable "vpc_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "ssh_private_key_path" {}
variable "ansible_inventory" {}
