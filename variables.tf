# Define AWS region, instance type, and AMI ID as variables
variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "key_name" {
  description = "The key pair name for SSH access"
  type        = string
}

variable "private_key_path" {
  description = "Path to your private SSH key"
  type        = string
}
