variable "region" {
  description = "AWS Region"
  type        = string
}

variable "namespace" {
  description = "Project Namespace"
  type        = string
}

variable "stage" {
  description = "Project Stage"
  type        = string
}

variable "name" {
  description = "Project Name"
  type        = string
}

variable "cidr_block" {
  description = "VPC cidr block"
  type        = string
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"
}

variable "enable_dns_hostnames" {
  description = "enable_dns_hostnames = true or false"
  type        = string
}

variable "enable_dns_support" {
  description = "enable_dns_support = true or false"
  type        = string
}

variable "enable_internet_gateway" {
  description = "enable_igw = true or false"
  type        = string
}

variable "nat_gateway_enabled" {
  description = "enable_nat_gateway = true or false"
  type        = string
}

variable "assign_generated_ipv6_cidr_block" {
  type        = string
  description = "IP Support"
}

variable "tags" {
  description = "VPC Tags"
  type        = map(string)
}

variable "ssh_public_key_path" {
  description = "ssh path for key"
  type        = string
  default     = "./secrets"
}

variable "generate_ssh_key" {
  description = "true or false"
  type        = string
}

variable "private_key_extension" {
  description = "private key extension"
  type        = string
}

variable "public_key_extension" {
  description = "public key extension"
  type        = string
}

variable "ami" {
  description = "AMI for bastion host"
  type        = string
}

variable "instance_type" {
  description = "Instance Type for Bastion Host"
  type        = string
}

variable "security_groups" {
  description = "security group for Bastion Host"
  type        = list(string)
  default     = []
}

variable "ingress_security_groups" {
  description = "Ingress security group for Bastion Host"
  type        = list(string)
  default     = []
}

variable "ssh_user" {
  description = "SSH User for Bastion Host"
  type        = string
}

variable "user_data" {
  description = "Userdata for Bastion Host"
  type        = list(string)
  default     = []
}

variable "rds_instance_type" {
  type        = string
  description = "RDS Instance type"
}

variable "rds_cluster_family" {
  type        = string
  description = "RDS Cluster Family"
}

variable "rds_cluster_size" {
  type        = string
  description = "rds_cluster_size"
}

variable "rds_deletion_protection" {
  type        = string
  description = "rds_deletion_protection"
}

variable "rds_autoscaling_enabled" {
  type        = string
  description = "RDS Autoscaling enabled"
}

variable "rds_engine" {
  type        = string
  description = "RDS Engine"
}

variable "rds_engine_mode" {
  type        = string
  description = "RDS Engine Mode"
}

variable "rds_db_name" {
  type        = string
  description = "DB Name"
}

variable "rds_admin_user" {
  type        = string
  description = "Admin User"
}

variable "rds_admin_password" {
  type        = string
  description = "Admin Password"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.18"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}


variable "local_exec_interpreter" {
  type = list(string)
  //default     = ["/bin/sh", "-c"]
  description = "shell to use for local_exec"
}


variable "oidc_provider_enabled" {
  type        = bool
  default     = true
  description = "Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using `kiam` or `kube2iam`. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "cluster_log_retention_period" {
  type        = number
  default     = 0
  description = "Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html."
}

variable "eks_nodes_instance_types" {
  type        = list(string)
  description = "EKS Node Instance type"
}

variable "desired_size" {
  type        = string
  description = "EKS Node Desired Size"
}

variable "min_size" {
  type        = string
  description = "EKS Node Min Size"
}

variable "max_size" {
  type        = string
  description = "EKS Node Max Size"
}

variable "rules_bastion" {
  type = list(any)
}

variable "bastion_cidr"{
    type = list(string)
    description = "List of Cidrs for Bastion"
    default = ["0.0.0.0/0"]
}

variable "bastion_egress_allowed" {
  type = bool
  description = "Bastion Egress?"
}

variable "eks_endpoint_private_access" {
  type = bool
  description = "EKS Private Access?"
}

variable "eks_endpoint_public_access" {
  type = bool
  description = "EKS Public Access?"
}

variable "eks_public_access_cidrs" {
    type = list(string)
    description = "EKS Cidr Public Access"
}
