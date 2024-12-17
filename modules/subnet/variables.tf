variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the subnet."
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the subnet."
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether instances in the subnet receive a public IP on launch."
  type        = bool
  default     = true
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}
