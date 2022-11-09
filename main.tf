#PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#REGION
provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.credentials_file
}

#MODULES
module "vpc" {
  source          = "./modules/vpc"

}

module "Camada1" {
  source            = "./modules/Camada1"
  sn_vpcgs_1a_id     = module.vpc.sn_vpcgs_1a_id
  sn_vpcgs_1c_id     = module.vpc.sn_vpcgs_1c_id
  sg_pub_id        = module.ec2.sg_pub_id 

}

module "Camada2" {
  source            = "./modules/Camada1"
  sn_vpcgs_2a_id     = module.vpc.sn_vpcgs_2a_id
  sn_vpcgs_2c_id     = module.vpc.sn_vpcgs_2c_id
  sg_priv_id        = module.ec2.sg_priv1_id 

}
    module "Camada3" {
  source            = "./modules/Camada3"
  sn_vpcgs_3a_id     = module.vpc.sn_vpcgs_3a_id
  sn_vpcgs_3c_id     = module.vpc.sn_vpcgs_3c_id
  sg_priv_id        = module.ec2.sg_priv2_id 

}
