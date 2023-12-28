locals {
  #env                                  = split("-", terraform.workspace)[2]
  project_name                          = "${var.organization}-${terraform.workspace}"
  cluster_id                            = var.cluster_id
  cluster_endpoint                      = var.cluster_endpoint
  eks_managed_node_groups_iam_role_arn  = var.eks_managed_node_groups_iam_role_arn
  eks_managed_node_groups_iam_role_name = var.eks_managed_node_groups_iam_role_name
  eks_oidc_provider_arn                 = var.eks_oidc_provider_arn
  base_domain                           = var.environment == "prod" ? "credmark.com" : "${var.environment}.credmark.com"
  argocd_base_domain                    = "cd.${local.base_domain}"
  argocd_path                           = "/argocd"
  argocd_dex_url                        = "https://${local.argocd_base_domain}${local.argocd_path}/api/dex"
  argo_workflow_base_domain             = "wf.${local.base_domain}"
  argo_workflow_sso_config = {
    secret_name = "argo-workflows-sso"
    secret_data = {
      "client-id"     = var.argocd_config.sso.github_client_id
      "client-secret" = var.argocd_config.sso.github_client_secret
    }
    redirect_url = "https://${local.argo_workflow_base_domain}/oauth2/callback"
  }
  tags = {
    Operator = "Terraform"
    Name     = local.project_name
  }
}

module "cert_manager" {
  source = "./cert-manager"
}

module "ingress_nginx" {
  source                = "./ingress-nginx"
  environment           = var.environment
  cluster_id            = local.cluster_id
  eks_oidc_provider_arn = local.eks_oidc_provider_arn
  acm_arn               = var.acm_arn
  depends_on = [
    module.cert_manager
  ]
}

module "argo_cd" {
  source                   = "./argo-cd"
  environment              = var.environment
  argocd_config            = var.argocd_config
  base_domain              = local.argocd_base_domain
  path                     = local.argocd_path
  argo_workflow_sso_config = local.argo_workflow_sso_config
  depends_on = [
    module.ingress_nginx
  ]
}

# # module "kubernetes_dashboard" {
# #   source = "./k8s-dashboard"
# # }


# # module "keda" {
# #   source = "./keda"
# #   depends_on = [
# #     module.argo_cd
# #   ]
# # }

# module "karpenter" {
#   source                                = "./karpenter"
#   cluster_id                            = local.cluster_id
#   cluster_endpoint                      = local.cluster_endpoint
#   eks_managed_node_groups_iam_role_arn  = local.eks_managed_node_groups_iam_role_arn
#   eks_managed_node_groups_iam_role_name = local.eks_managed_node_groups_iam_role_name
#   eks_oidc_provider_arn                 = local.eks_oidc_provider_arn
#   # depends_on = [
#   #   module.keda
#   # ]
# }

module "monitoring_logging" {
  source         = "./monitoring-logging"
  region         = var.region
  argocd_dex_url = local.argocd_dex_url
  environment    = var.environment
  # depends_on = [
  #   module.argo_cd
  # ]
}

module "argo_workflow" {
  source                   = "./argo-workflow"
  base_domain              = local.argo_workflow_base_domain
  argocd_dex_url           = local.argocd_dex_url
  argo_workflow_sso_config = local.argo_workflow_sso_config
  argo_s3_bucket           = var.argo_s3_bucket
  # depends_on = [
  #   module.argo_cd
  # ]
}


module "argo_events" {
  source = "./argo-events"
  # depends_on = [
  #   module.argo_workflow
  # ]
}

module "aws_nth" {
  source = "./aws-nth"
  depends_on = [
    module.argo_events
  ]
}


# module "cluster_autoscaler" {
#   source                = "./cluster-autoscaler"
#   cluster_id            = local.cluster_id
#   region                = var.region
#   eks_oidc_provider_arn = local.eks_oidc_provider_arn

# }

module "flink" {
  source = "./flink"

}