output "instance_id" {
  value = aws_instance.this.id
}

output "eip_public_ip" {
  value = aws_eip.this.public_ip
}
