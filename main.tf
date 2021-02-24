provider "aws" {
  region = var.region
}

module "vpc" {
  source                           = "cloudposse/vpc/aws"
  version                          = "0.21.1"
  namespace                        = var.namespace
  stage                            = var.stage
  name                             = var.name
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_internet_gateway          = var.enable_internet_gateway
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = var.tags

}

module "dynamic_subnets" {
  source              = "cloudposse/dynamic-subnets/aws"
  version             = "0.37.6"
  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  cidr_block          = var.cidr_block
  nat_gateway_enabled = var.nat_gateway_enabled

  tags = var.tags

}

module "ssh_key_pair" {
  source                = "cloudposse/key-pair/aws"
  version               = "0.18.0"
  namespace             = var.namespace
  stage                 = var.stage
  name                  = var.name
  ssh_public_key_path   = var.ssh_public_key_path
  generate_ssh_key      = var.generate_ssh_key
  private_key_extension = var.private_key_extension
  public_key_extension  = var.public_key_extension

  tags = var.tags

}


module "ec2_bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.21.0"

  ami           = var.ami
  instance_type = var.instance_type

  security_groups         = compact(concat([module.vpc.vpc_default_security_group_id], var.security_groups))
  //security_groups         = [module.security-group-bastion.id]
  ingress_security_groups = var.ingress_security_groups
  subnets                 = module.dynamic_subnets.public_subnet_ids
  ssh_user                = var.ssh_user
  key_name                = module.ssh_key_pair.key_name
  allowed_cidr_blocks     = var.bastion_cidr
  egress_allowed          = var.bastion_egress_allowed

  user_data = var.user_data
  vpc_id    = module.vpc.vpc_id
  name      = var.name

  tags = var.tags
}


module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.2"

  namespace = var.namespace
  stage     = var.stage
  name      = var.name

  tags = var.tags

}


module "eks-cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "0.34.1"
  
  region                       = var.region
  vpc_id                       = module.vpc.vpc_id
  //subnet_ids                   = concat(module.dynamic_subnets.private_subnet_ids, module.dynamic_subnets.public_subnet_ids)
  subnet_ids                   = module.dynamic_subnets.public_subnet_ids
  kubernetes_version           = var.kubernetes_version
  local_exec_interpreter       = var.local_exec_interpreter
  oidc_provider_enabled        = var.oidc_provider_enabled
  enabled_cluster_log_types    = var.enabled_cluster_log_types
  cluster_log_retention_period = var.cluster_log_retention_period
  workers_role_arns            = [ module.eks-node-group.eks_node_group_role_arn ]
  allowed_cidr_blocks          = var.bastion_cidr
  allowed_security_groups      = [ module.ec2_bastion.security_group_id ]
  endpoint_private_access   = var.eks_endpoint_private_access
  endpoint_public_access    = var.eks_endpoint_public_access
  public_access_cidrs       = var.eks_public_access_cidrs
  
}


module "eks-node-group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "0.18.3"

  namespace                 = var.namespace
  stage                     = var.stage
  name                      = var.name
  subnet_ids                = module.dynamic_subnets.public_subnet_ids
  instance_types            = var.eks_nodes_instance_types
  desired_size              = var.desired_size
  min_size                  = var.min_size
  max_size                  = var.max_size
  cluster_name              = module.eks-cluster.eks_cluster_id
  kubernetes_version        = var.kubernetes_version
  
}


/*
module "rds-cluster" {
  source  = "cloudposse/rds-cluster/aws"
  version = "0.42.1"

  namespace = var.namespace
  stage     = var.stage
  name      = var.name

  instance_type       = var.rds_instance_type
  cluster_family      = var.rds_cluster_family
  cluster_size        = var.rds_cluster_size
  deletion_protection = var.rds_deletion_protection

  autoscaling_enabled = var.rds_autoscaling_enabled
  engine              = var.rds_engine
  engine_mode         = var.rds_engine_mode
  db_name             = var.rds_db_name
  admin_user          = var.rds_admin_user
  admin_password      = var.rds_admin_password
  subnets             = module.dynamic_subnets.private_subnet_ids
  vpc_id              = module.vpc.vpc_id

}

module "security-group-bastion" {
  source  = "cloudposse/security-group/aws"
  version = "0.1.3"
  
  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  rules               = var.rules_bastion

  tags                = var.tags

}

*/
