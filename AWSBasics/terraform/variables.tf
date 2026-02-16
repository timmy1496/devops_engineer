variable "name" {
  type    = string
  default = "timmy"
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "az" {
  type    = string
  default = "eu-north-1a"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.10.2.0/24"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "timmy-key"
}

variable "create_key_pair" {
  type    = bool
  default = true
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
