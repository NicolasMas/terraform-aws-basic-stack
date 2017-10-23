# The VPC module

[Back](README.md)

For instance, a `terraform.tfvars` with the following variables

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
```
Will create the following VPC

**Note:**
- The main route table is not used, we rather create two public/private and we use them instead

- Each private subnet comes with a NAT Gateway because we set the parameter `"vpc-enable_nat_gateway"  = "true"` and consequently is associated an **EIP** addresse.

- Terraform does not check the network addressing logic, so you need to know what to input for the CIDR blocks.

![Simple VPC](README_ressources/Singapore-VPC.png?raw=true "Simple VPC")

A `terraform destroy` will bring the whole stack down and destroy all the ressources.

For the example, the region "Singapore" has two AZ ("ap-southeast-1a" and "ap-southeast-1b"), so we could create two public subnets and two private subnets, one in each AZ. The `terraform.tfvars` now looks like:

```terraform
# AWS Credz and region
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
```

Will create the following VPC (adding subnets will populate the second availability zone in the Singapore region).

![Simple 2AZ VPC](README_ressources/Singapore-2azs-VPC.png?raw=true "Simple VPC")
