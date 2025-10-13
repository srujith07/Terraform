terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "dev"        # change if your profile differs
  region  = "eu-west-1"  # change if needed
}

# Find latest Ubuntu 22.04 LTS (Jammy) AMI from Canonical
data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Default VPC and one of its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "in_default_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Simple SSH-only security group (for demo; restrict in real use)
resource "aws_security_group" "ssh" {
  name   = "hello-ssh"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # replace with your IP/CIDR later
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hello-ssh"
  }
}

# Choose the first subnet from the default VPC
locals {
  subnet_id = data.aws_subnets.in_default_vpc.ids[0]
}

# Instance 1
resource "aws_instance" "node1" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = "t2.micro"
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "hello-node-1"
  }
}

# Instance 2
resource "aws_instance" "node2" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = "t2.micro"
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "hello-node-2"
  }
}

# Outputs
output "node1_ip" {
  value = aws_instance.node1.public_ip
}

output "node2_ip" {
  value = aws_instance.node2.public_ip
}

