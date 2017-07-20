# A Terraform approach to building a solid infrastructure foundation on AWS
This is a WIP of a basic terraform + aws foundation code approach, trying to follow best practices. It's a base to build on. Reading the doc at [https://www.terraform.io/docs/index.html](https://www.terraform.io/docs/index.html) is highly advised.

## Setup

Requires:
- terraform binaries on your machine - if you are a mac user, you can use the package management system `homebrew` https://brew.sh/
(installing it is very easy). Once you are done, open a terminal and perform a `brew update && brew upgrade && brew install terraform`
- AWS account and the proper set of permission, plus a key-pair.

**Note:** you might incur some small charges from AWS (unless you are still on the free tier), so it's highly recommended to destroy the infra if you are not using it.

tested with:
- Terraform v0.9.8

To run this you need to clone this repository on your local machine, then with the console go to the `Singapore` directory. Inside the `terraform.tfvars` are a few variables to set: the `access_key`, the `secret_key` and the `keypair_name`.

Once done, you need to ensure terraform works properly
```shell
| ~/Development/Singapore @ nicolasmbp (nicolasmas)
| => terraform --version
Terraform v0.9.11
```

## Running it

First you need to retrieve the modules (for example:)
```shell
| ~/Development/Singapore @ nicolasmbp (nicolas)
| => terraform get
Get: file:///modules/m-vpc
Get: file:///modules/m-bastion
```

You are all set. Basic commands are:
```shell
terraform validate #syntax validation
terraform plan  #dry run
terraform apply #execute the code against AWS
terraform destroy #remove everything you just created from AWS
```

## Examples

- [A simple VPC in the Singapore region](VPC_ONLY.md)
<<<<<<< HEAD
- [A simple VPC with a bastion host in an autoscale group](VPC_BASTION.md)
=======
- A simple VPC with a bastion host in an autoscale group
>>>>>>> 8ed557c922da775bc6bf8beef6d8383f7f4afe55
