# generic
variable "m_o_name" {
  type = "string"
  default = "bastion"
}

variable "m_environment" {
  type = "string"
  default = "bastion"
}

variable "m_tags" {
  type = "map"
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "m_key_name" {
  type = "string"
  description = "The key name to connect to the ami instance"
  default     = ""
}

variable "m_enable_bastion" {
  type = "string"
  description = "should be true if you want to enable a bastion host"
  default     = false
}

variable "m_vpc_id" {
  type = "string"
  description = "The VPC in where the bastion should be created"
  default     = ""
}

# autoscale group
variable "m_enable_bastion_autoscale" {
  type = "string"
  description = "should be true if you want bastion host(s) to be put in an autoscale group"
  default     = false
}

variable "m_public_subnets" {
  type =  "list"
  description = "A list of public subnets inside the VPC to start the instances"
  default     = []
}
variable "m_availability_zones" {
  type =  "list"
  description = "A list of AZs inside the VPC to start the instances"
  default     = []
}

# ec2 instance
variable "m_bastion_class" {
  type = "string"
  description = "The machine class for the bastion (t2.nano, t2.small etc.)"
  default     = "t2.nano"
}

variable "m_bastion_ami_id" {
  type = "string"
  description = "The ami to be used for the bastion (default is the Amazon Linux - AMI 2017.03.1 (HVM), SSD Volume Type)"
  default     = "ami-77af2014"
}
