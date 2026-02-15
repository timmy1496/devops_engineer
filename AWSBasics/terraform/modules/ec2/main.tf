data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "this" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

locals {
  effective_key_name = var.create_key_pair ? aws_key_pair.this[0].key_name : var.key_name
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = local.effective_key_name

  tags = { Name = "${var.name}-ec2" }
}

resource "aws_eip" "this" {
  domain   = "vpc"
  tags = { Name = "${var.name}-eip" }
}

resource "aws_eip_association" "assoc" {
  allocation_id = aws_eip.this.id
  instance_id   = aws_instance.this.id
}
