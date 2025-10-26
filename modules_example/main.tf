# main.tf (Environment Context, Data Source, and Module Calls)

# --- 1. Provider and AMI Data Source ---
provider "aws" {
  region  = "eu-west-1" 
  profile = "dev"
}

# FIX: Dynamic lookup for the latest Ubuntu 22.04 LTS AMI (Jammy)
data "aws_ami" "ubuntu" {
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

# --- 2. Shared Network Resources ---

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "ExampleVPC" }
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true  
  availability_zone       = "eu-west-1a"
  tags = { Name = "ExampleSubnet" }
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
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

# --- 3. MODULE CALLS: The Reuse ---

# Instance 1: Web Server
module "web_server" {
  source                = "./modules/ec2" 
  
  instance_name         = "web-server-01" 
  ami_id                = data.aws_ami.ubuntu.id # PASSING THE DYNAMIC AMI ID
  subnet_id             = aws_subnet.example.id 
  security_group_id     = aws_security_group.ssh_access.id 
}

# Instance 2: App Server
module "app_server" {
  source                = "./modules/ec2"

  instance_name         = "app-server-02" 
  ami_id                = data.aws_ami.ubuntu.id # PASSING THE DYNAMIC AMI ID
  subnet_id             = aws_subnet.example.id 
  security_group_id     = aws_security_group.ssh_access.id 
}
