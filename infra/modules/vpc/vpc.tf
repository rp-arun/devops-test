locals {
  private_subnets = [
    cidrsubnet(var.cidr, 8, 1),
    cidrsubnet(var.cidr, 8, 2),
    cidrsubnet(var.cidr, 8, 3)
  ]

  public_subnets = [
    cidrsubnet(var.cidr, 8, 4),
    cidrsubnet(var.cidr, 8, 5),
    cidrsubnet(var.cidr, 8, 6)
  ]
  cluster_name = "devops-vpc"
  tags = {
    Operator = "Terraform"
    Name     = "devops-vpc"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
# Filter out opt-in availability zones (local zones, as an example)
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = local.cluster_name
  cidr = var.cidr

  azs                                = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets                    = local.private_subnets
  public_subnets                     = local.public_subnets
  enable_classiclink                 = null
  enable_classiclink_dns_support     = null
  enable_nat_gateway                 = true
  single_nat_gateway                 = true
  one_nat_gateway_per_az             = false
  
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = local.cluster_name
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = 1
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = local.tags
}
