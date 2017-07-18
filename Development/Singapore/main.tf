#
# Singapore Development Infrastructure
#

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

# VPC from modules
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
