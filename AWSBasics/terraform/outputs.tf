output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "security_group_id" {
  value = module.security.sg_id
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "instance_public_ip" {
  value = module.ec2.eip_public_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${module.ec2.eip_public_ip}"
}
