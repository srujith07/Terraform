# modules/ec2/variables.tf (Required Inputs)

variable "ami_id" {
  description = "The AMI ID for the instance."
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in."
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the instance."
  type        = string
}

variable "instance_name" {
  description = "The Name tag for the instance (unique per instance)."
  type        = string
}
