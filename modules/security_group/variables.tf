variable "security_group_name" {
  description = "The name of the security group."
  type        = string
}

variable "security_group_description" {
  description = "The description of the security group."
  type        = string
  default     = "Custom Security Group"
}

variable "vpc_id" {
  description = "The ID of the VPC to associate the security group with."
  type        = string
}

variable "ingress_from_port" {
  description = "The starting port for ingress traffic."
  type        = number
  default     = 22
}

variable "ingress_to_port" {
  description = "The ending port for ingress traffic."
  type        = number
  default     = 22
}

variable "ingress_protocol" {
  description = "The protocol for ingress traffic."
  type        = string
  default     = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks allowed for ingress."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_from_port" {
  description = "The starting port for egress traffic."
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "The ending port for egress traffic."
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "The protocol for egress traffic."
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks allowed for egress."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
