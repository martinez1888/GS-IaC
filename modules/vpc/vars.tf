#VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_dns_hostnames" {
  default = true
}

# SUBNETS
variable "sn_vpcgs_1a_cidr" {
  default = "10.0.1.0/24"
}

variable "sn_vpcgs_1c_cidr" {
  default = "10.0.2.0/24"
}

variable "sn_vpcgs_2a_cidr" {
  default = "10.0.3.0/24"
}

variable "sn_vpcgs_2c_cidr" {
  default = "10.0.4.0/24"
}


variable "sn_vpcgs_3a_cidr" {
  default = "10.0.5.0/24"
}

variable "sn_vpcgs_3c_cidr" {
  default = "10.0.6.0/24"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = "true"
}
