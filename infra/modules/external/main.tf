module "db_migration" {
  source = "./db-migration"
  providers = {
    postgresql.tsdb_cmk_db = postgresql.tsdb_cmk_db
  }
  service_user_password = var.tsdb_config.service_user_password
  db_name               = var.tsdb_config.db_name
  service_username      = var.tsdb_config.service_username
  cacert                = var.tsdb_cacert
  environment           = var.environment
}

module "secrets" {
  source                          = "./secrets"
  snowflake_account               = var.secrets_config.snowflake_account
  docker_registry_credentials     = var.secrets_config.docker_registry_credentials
  etherscan_api_key               = var.secrets_config.etherscan_api_key
  environment                     = var.environment
  tsdb_service_user_password      = var.tsdb_config.service_user_password
  tsdb_db_name                    = var.tsdb_config.db_name
  tsdb_service_username           = var.tsdb_config.service_username
  tsdb_cacert                     = var.tsdb_cacert
  tsdb_cmk_host                   = var.secrets_config.db_urls.cmk_host
  sf_model_runner_user            = var.snowflake_secrets.model_runner.sf_model_runner_user
  sf_model_runner_password        = var.snowflake_secrets.model_runner.sf_model_runner_password
  s3_bucket_name                  = var.snowflake_secrets.dbt.s3_bucket_name
  snowflake_aws_access_key_id     = var.snowflake_secrets.dbt.snowflake_aws_access_key_id
  snowflake_aws_secret_access_key = var.snowflake_secrets.dbt.snowflake_aws_secret_access_key
  dbt_sf_password                 = var.snowflake_secrets.dbt.dbt_sf_password
  dbt_sf_user                     = var.snowflake_secrets.dbt.dbt_sf_user
  pipeline_reader_user            = var.snowflake_secrets.abifetcher.pipeline_reader_user
  pipeline_reader_password        = var.snowflake_secrets.abifetcher.pipeline_reader_password
  sf_reporter_role                = var.snowflake_secrets.roles.sf_reporter_role
  sf_loader_role                  = var.snowflake_secrets.roles.sf_loader_role
  sf_transformer_role             = var.snowflake_secrets.roles.sf_transformer_role
  sf_reporting_warehouse          = var.snowflake_secrets.warehouses.sf_reporting_warehouse
  sf_loading_warehouse            = var.snowflake_secrets.warehouses.sf_loading_warehouse
  sf_transforming_warehouse       = var.snowflake_secrets.warehouses.sf_transforming_warehouse
  raw_database                    = var.snowflake_secrets.db.raw_database
  ethereum_database               = var.snowflake_secrets.db.ethereum_database
  rds_host                        = var.secrets_config.db_urls.rds_host
  price_db                        = var.secrets_config.db_urls.price_db
  price_user                      = var.secrets_config.db_urls.price_user
  price_user_password             = var.secrets_config.db_urls.price_user_password

}

module "argocd_manifests" {
  source      = "./argocd-manifests"
  environment = var.environment
  # depends_on = [
  #   module.db_migration,
  #   module.secrets
  # ]
}
