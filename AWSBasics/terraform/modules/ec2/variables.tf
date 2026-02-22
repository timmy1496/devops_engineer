variable "name" { type = string }
variable "subnet_id" { type = string }
variable "security_group_id" { type = string }
variable "instance_type" { type = string }

variable "key_name" { type = string }

variable "create_key_pair" {
  type    = bool
  default = true
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

# New: architecture to match instance type (e.g., x86_64 for t3.*, arm64 for t4g.*)
variable "architecture" {
  type    = string
  default = "x86_64"
  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "architecture must be either 'x86_64' or 'arm64'"
  }
}
