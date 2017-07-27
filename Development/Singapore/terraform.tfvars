# AWS
# We use Singapore
"region" = "ap-southeast-1"

# EC2 Key Pair
"keypair_name" = "NicolasEC2"

#
"name"        = "Singapore"
"environment" = "Development"

# VPC Configuration
"vpc-cidr"               = "10.0.0.0/16"
"vpc-tenancy"            = "default"
"vpc-public_subnets"     = ["10.0.0.0/24"]
"vpc-private_subnets"    = ["10.0.2.0/24"]
"vpc-enable_nat_gateway" = true
"enable_dns_support"     = true
"enable_dns_hostnames"   = true
"vpc-azs"                = ["ap-southeast-1a" , "ap-southeast-1b"]

#,"10.0.1.0/24"
#,"10.0.3.0/24"

# Bastion Configuration
"bastion-enabled-autoscale" = true

"bastion_class"             = "t2.micro"
