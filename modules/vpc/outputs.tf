output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.mbrapp.id
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = aws_subnet.public[*].id
}
