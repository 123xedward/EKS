region = "eu-central-1"

############## Project Information ##############
namespace = "EDP"
stage     = "Development"
name      = "EDP-Application"

############## Network ##############
cidr_block                       = "172.16.0.0/16"
availability_zones               = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
enable_dns_hostnames             = "true"
enable_dns_support               = "true"
enable_internet_gateway          = "true"
nat_gateway_enabled              = "true"
assign_generated_ipv6_cidr_block = "false"
tags = {
  "Name"        = "VPC Terraform"
  "Environment" = "Development"
  "Terraform"   = "yes"
}

############## Bastion Host ##############

ssh_public_key_path   = "./secrets"
generate_ssh_key      = "true"
private_key_extension = ".pem"
public_key_extension  = ".pub"

ami           = "ami-0a6dc7529cd559185"
instance_type = "t2.micro"
bastion_cidr  = ["32.32.32.32/32","0.0.0.0/0"]
bastion_egress_allowed = true

security_groups         = []
ingress_security_groups = []
ssh_user                = "ec2-user"
user_data               = []

rules_bastion = [
  {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    type        = "egress"
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
]


############## RDS Cluster ##############

rds_instance_type       = "db.t3.small"
rds_cluster_family      = "aurora5.6"
rds_cluster_size        = 2
rds_deletion_protection = false
rds_autoscaling_enabled = false
rds_engine              = "aurora"
rds_engine_mode         = "provisioned"
rds_db_name             = "test_db"
rds_admin_user          = "admin"
rds_admin_password      = "admin_password"

############## EKS Cluster ##############
kubernetes_version = "1.18"
local_exec_interpreter = ["/bin/sh", "-c"]
//local_exec_interpreter       = ["PowerShell", "-Command"]
oidc_provider_enabled        = true
enabled_cluster_log_types    = ["audit"]
cluster_log_retention_period = 7

eks_nodes_instance_types = ["t2.micro"]
desired_size             = 1
min_size                 = 1
max_size                 = 3
eks_endpoint_private_access = false
eks_endpoint_public_access = true
eks_public_access_cidrs = ["32.32.32.32/32","0.0.0.0/0"]
