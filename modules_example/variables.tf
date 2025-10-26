# variables.tf (Root Variables)

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-west-1" # Ireland/Dublin
}
