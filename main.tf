provider "aws" {
  region = "us-east-1"
}

# Generate a new SSH key pair using TLS
resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair using the generated public key
resource "aws_key_pair" "web_key" {
  key_name   = "web-key"
  public_key = tls_private_key.web_key.public_key_openssh
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
    cidr_block
