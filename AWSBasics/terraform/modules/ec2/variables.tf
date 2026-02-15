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
