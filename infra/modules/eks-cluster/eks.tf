data "aws_caller_identity" "current" {}
module "eks" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
  source  = "terraform-aws-modules/eks/aws"
  version = "18.28.0"

  cluster_name    = "devops-cluster-prod"
  cluster_version = "1.28"

  # # aws-ebs-csi-driver plugin 
  # cluster_addons = {
  #   aws-ebs-csi-driver = {
  #     resolve_conflicts        = "OVERWRITE"
  #     service_account_role_arn = module.aws_ebs_csi_driver_irsa_role.iam_role_arn
  #   }
  # }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_irsa = true

  # We will rely only on the cluster security group created by the EKS service
  # See note below for `tags`
  create_cluster_security_group = false
  create_node_security_group    = false

  # This ensures core services such as VPC CNI, CoreDNS, etc. are up and running
  eks_managed_node_groups = {
    default= {
      instance_types = ["t2.medium"]
      create_security_group                 = false
      attach_cluster_primary_security_group = true

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }

  }


}

#ISRA for aws-ebs-csi-driver

# module "aws_ebs_csi_driver_irsa_role" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name = "aws-ebs-csi-driver"

#   attach_ebs_csi_policy = true

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
#     }
#   }
# }
