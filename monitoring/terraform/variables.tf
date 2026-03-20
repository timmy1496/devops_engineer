variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "monitoring-stack"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH and admin access (your IP)"
  type        = string
  # IMPORTANT: Replace with your actual IP: curl ifconfig.me
  default     = "0.0.0.0/0"
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "private_key_path" {
  description = "Path to SSH private key for Ansible inventory"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "ssh_user" {
  description = "SSH user for EC2 instances (Ubuntu AMI)"
  type        = string
  default     = "ubuntu"
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "monitoring-stack"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
