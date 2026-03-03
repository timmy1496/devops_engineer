output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.this.public_ip
}

output "s3_bucket_name" {
  description = "Created S3 bucket name"
  value       = aws_s3_bucket.private.bucket
}
