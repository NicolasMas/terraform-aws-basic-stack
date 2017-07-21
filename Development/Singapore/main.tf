#
# Singapore Development Infrastructure
#

provider "aws" {
    profile = "nicolas-dev"
    region = "${var.region}"
}

# VPC from modules
# Loading the module and passing variables
module "VPC"{
  source = "../../modules/m-vpc"
  # required variables  [terraform - AWS Scope]
  # won't work without it
  # VPC
  m_cidr                 = "${var.vpc-cidr}"
  m_enable_dns_support   = true
  m_enable_dns_hostnames = true
  # subnets
  ## public
  m_public_subnets  = "${var.vpc-public_subnets}"
  ## private
  m_private_subnets = "${var.vpc-private_subnets}"
  # nat gateway
  # enabling nat gateways for the private subnets allows instances to connect
  # to internet (but they can't be accessed from internet)
  m_enable_nat_gateway  = "${var.vpc-enable_nat_gateway}"
  # availability zones
  m_azs = "${var.vpc-azs}"

  # optional variables  [terraform - AWS Scope]
  # recommended to setup
    m_o_name             = "${var.name}"
    m_o_instance_tenancy   = "${var.vpc-tenancy}"
  # custom variables    [this script - Scope]
    m_o_memory           = "1G"

  # tagging
  m_tags {
    "Terraform" = "true"
    "Environment" = "${var.environment}"
  }

}

module "BASTION"{
  source = "../../modules/m-bastion"
  m_environment = "${var.environment}"
  # required variables  [terraform - AWS Scope]
  # won't work without it
  #
  m_enable_bastion   = "${var.bastion-enabled}"
  m_enable_bastion_autoscale = "${var.bastion-enabled-autoscale}"

  # which vpc will the bastion be attached
  m_vpc_id    = "${module.VPC.vpc_id}"

  # launch configuration
  m_bastion_class = "${var.bastion_class}"
  m_bastion_ami_id  = "${var.bastion_ami_id}"
  m_key_name  = "${var.keypair_name}"

  # autoscale group
  m_public_subnets  = "${module.VPC.public_subnets}"


  # optional variables  [terraform - AWS Scope]
  # recommended to setup
  m_o_name    = "${var.name}"

  # tagging
  m_tags {
    "Terraform" = "true"
    "Environment" = "${var.environment}"
  }
}

# outputs
output  "vpc_id" {
    value = "${module.VPC.vpc_id}"
}
output  "vpc_cidr" {
    value = "${module.VPC.cidr}"
}
output  "vpc_tenancy" {
    value = "${module.VPC.tenancy}"
}

output "vpc_default_security_group" {
  value = "${module.VPC.vpc_default_security_group}"
}

output "private_subnets" {
  value = ["${module.VPC.private_subnets}"]
}

output "public_subnets" {
  value = ["${module.VPC.public_subnets}"]
}

output "public_route_table_ids" {
  value = ["${module.VPC.public_route_table_ids}"]
}

output "private_route_table_ids" {
  value = ["${module.VPC.private_route_table_ids}"]
}

output "default_security_group_id" {
  value = "${module.VPC.default_security_group_id}"
}

output "nat_eips" {
  value = ["${module.VPC.nat_eips}"]
}

output "igw_id" {
  value = "${module.VPC.igw_id}"
}

output "memory" {
    value = "${module.VPC.memory}"
}

output "bastion_enable" {
    value = "${module.BASTION.enable_bastion}"
}

output "enable_bastion_autoscale" {
    value = "${module.BASTION.enable_bastion_autoscale}"
}
