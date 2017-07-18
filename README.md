# terraform-aws
Basic terraform + aws foundation, leveraging on modules when possible. It's a base to build on.

Requires:
terraform binaries
tested with versions:
- Terraform v0.9.8
- 



For instance, a `terraform.tfvars` with the following variables

```terraform
# AWS Credz and region
"access_key" = "change_for_your_access_key"
"secret_key" = "change_for_your_secret_key"
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

Will create the following VPC

**Note:**
- The main route table is not used, we rather create two public/private and we use them instead

- Each private subnet comes with a NAT Gateway because we set the parameter `"vpc-enable_nat_gateway"  = "true"` and consequently is associated an **EIP** addresse.

- Terraform does not check the network addressing logic, so you need to know what to input for the CIDR blocks.

![Simple VPC](README_ressources/Singapore-VPC.png?raw=true "Simple VPC")

A `terraform destroy` will bring the whole stack down and destroy all the ressources.

Modifying the `terraform.tfvars` like this:

```terraform
# AWS Credz and region
"access_key" = "change_for_your_access_key"
"secret_key" = "change_for_your_secret_key"
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
