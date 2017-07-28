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
variable "enable_dns_support"  {type = "string"}
variable "enable_dns_hostnames"  {type = "string"}
variable "vpc-azs"  {type = "list"}


# Contract with m-bastion-module
variable "bastion_class" {type = "string"}
variable "bastion-enabled-autoscale" {type = "string"}
