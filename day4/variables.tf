variable "aws_region" {}
variable "env" {}

variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "public_subnet_cidr_2" {}
variable "private_subnet_cidr_2" {}

variable "strapi_port" {
  description = "Port on which Strapi runs"
  default     = 1337
}

variable "instance_type" {}
variable "key_name" {}

