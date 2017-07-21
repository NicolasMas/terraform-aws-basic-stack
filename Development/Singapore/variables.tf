# AWS
variable "keypair_name" {type = "string"}
variable "region" {type = "string"}

# Contract with m-vpc-module
variable "name" {type = "string"}
variable "environment" {type = "string"}
variable "vpc-cidr" {type = "string"}
variable "vpc-tenancy"  {type = "string"}
variable "vpc-public_subnets" {type = "list"}
variable "vpc-private_subnets"  {type = "list"}
variable "vpc-enable_nat_gateway" {type = "string"}
variable "vpc-azs"  {type = "list"}


# Contract with m-bastion-module (if enabled)
#variable "enable_bastion" {type = "string"}
#variable "enable_bastion_autoscale" {type = "string"}
variable "bastion_class" {type = "string"}
variable "bastion_ami_id" {type = "string"}
variable "bastion-enabled" {}
variable "bastion-enabled-autoscale" {}
