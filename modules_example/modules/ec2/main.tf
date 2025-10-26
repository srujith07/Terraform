# modules/ec2/main.tf (The Blueprint)

resource "aws_instance" "example" {
  # AMI ID is now a variable again, passed from the root configuration
  ami           = var.ami_id
  instance_type = "t2.micro" 
  
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = var.instance_name
  }
}
