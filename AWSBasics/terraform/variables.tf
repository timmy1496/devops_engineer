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
  default = "t3.micro"
}

variable "architecture" {
  type    = string
  default = "x86_64"
  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "architecture must be either 'x86_64' or 'arm64'"
  }
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
