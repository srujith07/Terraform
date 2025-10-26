# modules/ec2/outputs.tf

output "public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.example.public_ip
}
