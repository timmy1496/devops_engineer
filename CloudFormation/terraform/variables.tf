variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-north-1"
}

variable "project_name" {
  type        = string
  description = "Prefix for resource names"
  default     = "tf-task"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name"
  default = "timmy-bucket-1234567890"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 KeyPair name for SSH"
}