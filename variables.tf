variable "vpc" {
  type = object({
    is_enable_natgw      = bool
    is_enable_vpngw      = bool
    is_single_natgw      = bool
    is_one_natgw_per_az  = bool
    is_create_db_sub_grp = bool
    is_create_db_sub_rt  = bool
  })

  default = {
    is_create_db_sub_rt  = true
    is_create_db_sub_grp = true
    is_enable_natgw      = true
    is_enable_vpngw      = false
    is_one_natgw_per_az  = false
    is_single_natgw      = true
  }

  description = <<EOF
  Group variables of aws vpc looks like this:
  ```
  vpc = {
    is_enable_vpngw      = false
    is_enable_natgw      = true
    is_single_natgw      = true
    is_one_natgw_per_az  = false
    is_create_db_sub_grp = true
    is_create_db_sub_rt  = true
  }```
  EOF
}

variable "instances" {
  type = map(any)
  default = {
    "bastion" = {
      distro        = "ubuntu"
      instance_type = "t2.micro"
      ssh_key       = "ncz"
      is_mon        = true
      encrypted     = true
      volume_type   = "gp2"
      volume_size   = 10
      sg            = "ssh_sg"
      network       = "public3"
    },
    "web1" = {
      distro        = "centos"
      instance_type = "t3.micro"
      ssh_key       = "ncz"
      is_mon        = false
      encrypted     = true
      volume_type   = "gp2"
      volume_size   = 10
      sg            = "web_sg"
      network       = "private1"
    }
  }
}
