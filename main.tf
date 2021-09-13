locals {
  project_name = "lts"
  owner        = "Platform-team"
  region       = "us-west-1"
  env          = "development"
  subnets      = chunklist([for x in cidrsubnets("10.0.0.0/12", 12, 12, 12, 12, 12, 12, 12, 12, 12, 12) : x if x != cidrsubnets("10.0.0.0/12", 12)[0]], 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = join("-", [local.project_name, "vpc"])
  cidr = cidrsubnets("10.0.0.0/12", 4)[0]

  azs              = [for x in ["a", "b", "c"] : "${local.region}${x}"]
  public_subnets   = local.subnets[0]
  private_subnets  = local.subnets[1]
  database_subnets = local.subnets[2]

  enable_nat_gateway                 = var.vpc.is_enable_natgw
  one_nat_gateway_per_az             = var.vpc.is_one_natgw_per_az
  single_nat_gateway                 = var.vpc.is_single_natgw
  enable_vpn_gateway                 = var.vpc.is_enable_vpngw
  create_database_subnet_group       = var.vpc.is_create_db_sub_grp
  create_database_subnet_route_table = var.vpc.is_create_db_sub_rt

  tags = {
    Owner       = local.owner
    Environment = local.env
  }

}
