# AWS Credentials
variable "access_key"  {type = "string"}
variable "secret_key"  {type = "string"}
variable "keypair_name" {type = "string"}
variable "region" {type = "string"}

variable "name" {type = "string"}
variable "environment" {type = "string"}
variable "vpc-cidr" {type = "string"}
variable "vpc-tenancy"  {type = "string"}
variable "vpc-public_subnets" {type = "list"}
variable "vpc-private_subnets"  {type = "list"}
variable "vpc-enable_nat_gateway" {type = "string"}
variable "vpc-azs"  {type = "list"}
