variable "vpc" {
  type = object({
    is_enable_natgw         = bool
    is_enable_vpngw         = bool
    is_single_natgw         = bool
    is_one_natgw_per_az     = bool
    is_create_db_subnet_grp = bool
    is_create_db_sub_rt     = bool
  })

  default = {
    is_create_db_sub_rt     = true
    is_create_db_subnet_grp = true
    is_enable_natgw         = true
    is_enable_vpngw         = false
    is_one_natgw_per_az     = false
    is_single_natgw         = true
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
