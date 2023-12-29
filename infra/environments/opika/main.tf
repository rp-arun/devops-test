locals {
  region       = "us-west-2"
  cluster_name = "devops-cluster-prod"
}

module "vpc" {
  source       = "../../modules/vpc"
}

module "eks" {
  source       = "../../modules/eks-cluster"
  vpc_id       = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  depends_on = [
    module.vpc
  ]
}


