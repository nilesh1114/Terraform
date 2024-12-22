# Output the public IP of the EC2 instance
output "instance_ip" {
  value = aws_instance.web.public_ip
}
