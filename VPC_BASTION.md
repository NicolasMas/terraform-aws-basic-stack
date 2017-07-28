# The Bastion module

[Back](README.md)

On top of our VPC, we can add a bastion host, inside a launch_configuration and Autoscaling strategy to ensure that no matter what, there is always a bastion per AZ up and running for us to access the private subnets. For more info on what a Bastion is:
[AWS Bastion Host post on the security blog ](https://aws.amazon.com/blogs/security/tag/bastion-host/)

**Note:** The bastion comes as naked as it could be. You need to decide later on about the SSH strategy you would like to implement (SSH FORWARD vs SSH PROXY). The bash script which comes with the module does nothing, you want to modify it to fit your requirements.

**Note:** Setting the parameter:
 ```terraform
 "bastion-enabled-autoscale" = false```

Will skip the creation of the bastion and the autoscale architecture altogether. In other word, either the bastion comes in an autoscaling context or it does not come at all. (terraform does not allow yet a clean way to implement a "if enabled_bastion == true, execute the module, else don't").

A `terraform.tfvars` with the following variables

```terraform
# AWS region
"region" = "ap-southeast-1"

# EC2 Key Pair
"keypair_name" = "AwsDevops"

# Tags
"name"        = "Singapore-VPC"
"environment" = "Development"

# networking
"vpc-cidr"    = "10.0.0.0/16"
"vpc-tenancy" = "default"
"vpc-public_subnets"  = ["10.0.0.0/24"]
"vpc-private_subnets" = ["10.0.2.0/24"]
"vpc-enable_nat_gateway"  = "true"
"vpc-azs" = ["ap-southeast-1a" , "ap-southeast-1b"]

# Bastion Configuration
"bastion-enabled-autoscale" = true
"bastion_class"             = "t2.micro"
```
And the following `main.tf`

```terraform
#
# Singapore Development Infrastructure
#

provider "aws" {
    profile = "terraform-dev"
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

  # Generic tagging across all modules
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
  m_enable_bastion_autoscale = "${var.bastion-enabled-autoscale}"
  # which vpc will the bastion be attached
  m_vpc_id    = "${module.VPC.vpc_id}"
  # launch configuration
  m_bastion_class = "${var.bastion_class}"
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
```
Will create

![Simple VPC with an autoscale bastion](README_ressources/VPC-Bastion-ASG-1AZ.png?raw=true "VPC + Bastion")

For a multiAZ the `terraform.tfvars` will look like this
A `terraform.tfvars` with the following variables

```terraform
# AWS region
"region" = "ap-southeast-1"

# EC2 Key Pair
"keypair_name" = "AwsDevops"

# Tags
"name"        = "Singapore-VPC"
"environment" = "Development"

# networking
"vpc-cidr"    = "10.0.0.0/16"
"vpc-tenancy" = "default"
"vpc-public_subnets"  = ["10.0.0.0/24","10.0.1.0/24"]
"vpc-private_subnets" = ["10.0.2.0/24","10.0.3.0/24"]
"vpc-enable_nat_gateway"  = "true"
"vpc-azs" = ["ap-southeast-1a" , "ap-southeast-1b"]

# Bastion Configuration
"bastion-enabled-autoscale" = true
"bastion_class"             = "t2.micro"
```



![Multi AZ VPC with autoscale bastions](README_ressources/VPC-Bastion-ASG-2AZ.png?raw=true "VPC + Bastion")
