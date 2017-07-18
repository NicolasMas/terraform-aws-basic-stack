# AWS Credz and region
"access_key" = "your_acess_key"
"secret_key" = "your_secret_key"
#We use Singapore
"region" = "ap-southeast-1"

# EC2 Key Pair
"keypair_name" = "your_key"

# Custom variables
"name"        = "Singapore-VPC"
"environment" = "Development"


# Networking parameters
"vpc-cidr"    = "10.0.0.0/16"
"vpc-tenancy" = "default"
"vpc-public_subnets"  = ["10.0.0.0/24"]
"vpc-private_subnets" = ["10.0.2.0/24"]
"vpc-enable_nat_gateway"  = "true"
"vpc-azs" = ["ap-southeast-1a" , "ap-southeast-1b"]
