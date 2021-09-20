locals {
  project_name = "lts"
  owner        = "Platform-team"
  region       = "us-east-1"
  env          = "development"
  subnets      = chunklist([for x in cidrsubnets("10.0.0.0/12", 12, 12, 12, 12, 12, 12, 12, 12, 12, 12) : x if x != cidrsubnets("10.0.0.0/12", 12)[0]], 3)

  distro = {
    ubuntu = data.aws_ami.ubuntu.id
    centos = data.aws_ami.centos.id
    ecs    = data.aws_ami.ecs
  }

  network = {
    public1  = module.vpc.public_subnets[0]
    public2  = module.vpc.public_subnets[1]
    public3  = module.vpc.public_subnets[2]
    private1 = module.vpc.private_subnets[0]
    private2 = module.vpc.private_subnets[1]
    private3 = module.vpc.private_subnets[2]
    db1      = module.vpc.database_subnets[0]
    db2      = module.vpc.database_subnets[1]
    db3      = module.vpc.database_subnets[2]
  }

  sg = {
    ssh_sg = module.ssh_sg.security_group_id
    web_sg = module.web_sg.security_group_id
  }

  ssh_key = {
    ncz = aws_key_pair.ncz_key.key_name
  }
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

resource "aws_key_pair" "ncz_key" {
  key_name   = "ncz_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG0Yp+NQiMMFSo56kOghYVQIpkV8dM++xRkK5VipKkhQu9HiUCP+zMcTKple4y+04TckUfYthpLphLA9pMIswocN44U1NJO/nW9TTmEWKllPOSzM67CvyoI9Brwc75V436mnResu9Vmx9A5Bn4AFiwEFIEaabpHoZhgBZjSL/v1oZGzr+UiFbboGCtOCfO6ohj8eo5T0z/wHtFBoeqKLX5cM0Z36Oa4uSX9dghXfAAVfjxGHY6XzELg39Mbusowb/HX/WEP04A48xwb8q253AqknMTCLaLNBAxaOwLViOlF7cxhVt8bmOqy+NpRTOIXcC9B/CS76h0Rx0g1Kmy25KZ"
}

module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "4.3.0"

  name                = join("-", [local.project_name, "bastionsg"])
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "web_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "4.3.0"

  name                = join("-", [local.project_name, "web"])
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.1.0"

  for_each = var.instances

  name = join("-", [local.project_name, each.key])

  ami                    = coalesce(local.distro[each.value.distro], each.value.distro)
  instance_type          = each.value.instance_type
  key_name               = coalesce(local.ssh_key[each.value.ssh_key], each.value.ssh_key)
  monitoring             = each.value.is_mon
  vpc_security_group_ids = [coalesce(local.sg[each.value.sg], each.value.sg)]
  subnet_id              = coalesce(local.network[each.value.network], each.value.network)

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}
