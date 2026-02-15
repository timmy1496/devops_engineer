provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source = "./modules/vpc"

  name             = var.name
  vpc_cidr         = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az               = var.az
}

module "security" {
  source = "./modules/security"

  name      = var.name
  vpc_id    = module.vpc.vpc_id
  vpc_cidr  = var.vpc_cidr
  public_subnet_id  = module.vpc.public_subnet_id
}

module "ec2" {
  source = "./modules/ec2"

  name              = var.name
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security.sg_id

  instance_type = var.instance_type
  key_name      = var.key_name
  create_key_pair = var.create_key_pair
  public_key_path = var.public_key_path
}
