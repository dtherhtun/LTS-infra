# LTS Infra

## Introduction

You are working for an company and they want to host their application on AWS. You are an Ops for the company and you are responsible to do the follows.


## Requirements

1. Create a custom vpc with public subnet, private subnet, and database subnet on multi az using Terraform
2. Create a bastion host with ssh key and security group that is only allow ssh port from 0.0.0.0/0.
3. Create a instance in private network and export public ip via output.

## Informations
- VPC = 10.0.0.0/16
- PUBLIC subnet = 10.0.1-3.0/24
- PRIVATE subnet = 10.0.4-5.0/24
- DB subnet = 10.0.7-9.0/24
- Can't afford costs for NAT gateway in every az
- Create only one NAT gateway
- Disable vpn gateway
- Create db subnet group
- Create db subnet route table


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.57.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | 3.1.0 |
| <a name="module_ssh_sg"></a> [ssh\_sg](#module\_ssh\_sg) | terraform-aws-modules/security-group/aws//modules/ssh | 4.3.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.7.0 |
| <a name="module_web_sg"></a> [web\_sg](#module\_web\_sg) | terraform-aws-modules/security-group/aws//modules/http-80 | 4.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.ncz_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_ami.centos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instances"></a> [instances](#input\_instances) | n/a | `map(any)` | <pre>{<br>  "bastion": {<br>    "distro": "ubuntu",<br>    "instance_type": "t2.micro",<br>    "is_mon": true,<br>    "network": "public3",<br>    "sg": "ssh_sg",<br>    "ssh_key": "ncz"<br>  },<br>  "web1": {<br>    "distro": "centos",<br>    "instance_type": "t3.micro",<br>    "is_mon": false,<br>    "network": "private1",<br>    "sg": "web_sg",<br>    "ssh_key": "ncz"<br>  }<br>}</pre> | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | Group variables of aws vpc looks like this:<pre>vpc = {<br>    is_enable_vpngw      = false<br>    is_enable_natgw      = true<br>    is_single_natgw      = true<br>    is_one_natgw_per_az  = false<br>    is_create_db_sub_grp = true<br>    is_create_db_sub_rt  = true<br>  }</pre> | <pre>object({<br>    is_enable_natgw      = bool<br>    is_enable_vpngw      = bool<br>    is_single_natgw      = bool<br>    is_one_natgw_per_az  = bool<br>    is_create_db_sub_grp = bool<br>    is_create_db_sub_rt  = bool<br>  })</pre> | <pre>{<br>  "is_create_db_sub_grp": true,<br>  "is_create_db_sub_rt": true,<br>  "is_enable_natgw": true,<br>  "is_enable_vpngw": false,<br>  "is_one_natgw_per_az": false,<br>  "is_single_natgw": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web1_public_ip"></a> [web1\_public\_ip](#output\_web1\_public\_ip) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
