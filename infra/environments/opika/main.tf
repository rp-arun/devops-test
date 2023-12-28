locals {
  region       = "us-west-2"
  cluster_name = "devops-cluster"
}

module "vpc" {
  source       = "../../modules/vpc"
}

module "eks" {
  source       = "../../modules/eks-cluster"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  depends_on = [
    module.vpc
  ]
}

# module "helm" {
#   source                                = "../../modules/helm-packages"
#   region                                = local.region
#   cluster_id                            = module.eks.cluster_id
#   eks_managed_node_groups_iam_role_name = module.eks.eks_managed_node_groups_iam_role_name
#   eks_managed_node_groups_iam_role_arn  = module.eks.eks_managed_node_groups_iam_role_arn
#   eks_oidc_provider_arn                 = module.eks.eks_oidc_provider_arn
#   cluster_endpoint                      = module.eks.cluster_endpoint
#   # git credentials for argocd
#   argocd_config = {
#     githubAppID             = var.HELM_ARGOCD_GITHUB_APP_ID
#     githubAppInstallationID = var.HELM_ARGOCD_GITHUB_APP_INSTALLATION_ID
#     githubAppPrivateKey     = var.HELM_ARGOCD_GITHUB_APP_PRIVATE_KEY
#     sso = {
#       github_client_id     = var.HELM_ARGOCD_DEX_GITHUB_CLIENT_ID
#       github_client_secret = var.HELM_ARGOCD_DEX_GITHUB_CLIENT_SECRET
#       allowed_team         = var.HELM_ARGOCD_DEX_GITHUB_ALLOWED_TEAM
#       github_org           = var.HELM_ARGOCD_DEX_GITHUB_ORG
#     }
#   }
#   environment    = local.environment
#   argo_s3_bucket = "credmark-snowflake-prod-cmk-labs" #module.snowflake.snowflake_s3_bucket_name
#   # depends_on = [
#   #   module.eks
#   # ]

# }


# module "external" {
#   source = "../../modules/external"
#   # Provider configuration for Timescale db migration
#   providers = {
#     postgresql.tsdb_cmk_db = postgresql.tsdb_cmk_db
#   }

#   # vars for tsdb migration
#   tsdb_config = {
#     db_name               = var.DB_MIGRATION_DB_NAME
#     service_username      = var.DB_MIGRATION_SERVICE_USERNAME
#     service_user_password = var.DB_MIGRATION_SERVICE_USER_PASSWORD
#   }

#   # vars for secrets
#   secrets_config = {
#     db_urls = {
#       cmk_host            = "var.TSDB_HOST"
#       rds_host            = "module.ops_db.db_host"
#       price_db            = var.PRICE_DB
#       price_user          = var.PRICE_USER
#       price_user_password = var.PRICE_USER_PASSWORD
#     }
#     docker_registry_credentials = var.SECRETS_DOCKER_REGISTRY_CREDENTIALS
#     etherscan_api_key           = var.SECRETS_ETHERSCAN_API_KEY
#     snowflake_account           = var.SECRETS_SNOWFLAKE_ACCOUNT
#   }

#   snowflake_secrets = {
#     # For model runner 
#     model_runner = {
#       sf_model_runner_user     = "var.CREMARK_MODEL_RUNNER_API_USER"
#       sf_model_runner_password =" var.CREMARK_MODEL_RUNNER_API_PASSWORD"
#     }

#     # For dbt
#     dbt = {
#       s3_bucket_name                  = "module.snowflake.snowflake_s3_bucket_name"
#       snowflake_aws_access_key_id     = "module.snowflake.snowflake_user_access_key_id"
#       snowflake_aws_secret_access_key = "module.snowflake.snowflake_user_access_key_secret"
#       dbt_sf_password                 = "module.snowflake.dbt_sf_password"
#       dbt_sf_user                     = "module.snowflake.dbt_sf_user"
#     }

#     # For abifetcher
#     abifetcher = {
#       pipeline_reader_user     = "module.snowflake.pipeline_reader_user"
#       pipeline_reader_password = "module.snowflake.pipeline_reader_password"
#     }

#     # Roles 
#     roles = {
#       sf_reporter_role    = data.terraform_remote_state.snowflake.outputs.sf_reporter_role
#       sf_loader_role      = data.terraform_remote_state.snowflake.outputs.sf_loader_role
#       sf_transformer_role = data.terraform_remote_state.snowflake.outputs.sf_transformer_role
#     }

#     # Warehouses
#     warehouses = {
#       sf_reporting_warehouse    = data.terraform_remote_state.snowflake.outputs.sf_reporting_warehouse
#       sf_loading_warehouse      = data.terraform_remote_state.snowflake.outputs.sf_loading_warehouse
#       sf_transforming_warehouse = data.terraform_remote_state.snowflake.outputs.sf_transforming_warehouse
#     }

#     # Databases
#     db = {
#       raw_database      = data.terraform_remote_state.snowflake.outputs.sf_raw_db
#       ethereum_database = data.terraform_remote_state.snowflake.outputs.sf_analytics_db
#     }

#   }

#   tsdb_cacert = var.DB_MIGRATION_CACERT
#   environment = local.environment

# }


