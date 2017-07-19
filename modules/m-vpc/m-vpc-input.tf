#
# variable types (optional)
#   string
#   list
#   map
#
# "description": human friendly description for a better code understanding
#
# module variables start with "m_"
# optional variables start with "m_o_"
#

variable "m_environment" {
  type = "map"
  default = {}
}

variable "m_cidr" {
  type = "string"
  description = "VPC CIDR is to be determined by the module caller thus default overriden"
  default = "10.0.0.0/16"
}

variable "m_enable_dns_support" {
  type = "string"
  description = "should be true if you want to use private DNS within the VPC"
  default = "false"
}

variable "m_enable_dns_hostnames" {
  type = "string"
  description = "should be true if you want to use private DNS within the VPC"
  default = "false"
}

variable "m_public_subnets" {
  type =  "list"
  description = "A list of public subnets inside the VPC."
  default     = []
}

variable "m_private_subnets" {
  type = "list"
  description = "A list of private subnets inside the VPC."
  default     = []
}

variable "m_azs" {
  type = "list"
  description = "A list of Availability zones in the region"
  default     = []
}

variable "m_enable_nat_gateway" {
  type = "string"
  description = "should be true if you want to provision NAT Gateways for each of your private networks"
  default     = "false"
}

variable "m_map_public_ip_on_launch" {
  type = "string"
  description = "should be false if you do not want to auto-assign public IP on launch"
  default     = "true"
}

variable "m_private_propagating_vgws" {
  type = "list"
  description = "A list of VGWs the private route table should propagate."
  default     = []
}

variable "m_public_propagating_vgws" {
  type = "list"
  description = "A list of VGWs the public route table should propagate."
  default     = []
}

variable "m_o_name" {
  type = "string"
  default = "vpc"
}

variable "m_o_instance_tenancy" {
  type = "string"
  description = "allowed tenancy of instances for the VPC. can be 'default', 'dedicated', 'host'"
  default = "default"
}

variable "m_o_memory" {
  type = "string"
  description = "Example for the module output"
  default = "12G"
}

variable "m_tags" {
  type = "map"
  description = "A map of tags to add to all resources"
  default     = {}
}
