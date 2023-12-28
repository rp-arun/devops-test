variable "environment" {
  type        = string
  description = "environment prod or staging"
  validation {
    condition     = contains(["staging", "prod", "staging2"], var.environment)
    error_message = "The environment must be one of [\"staging\", \"prod\"]."
  }
}

variable "tsdb_config" {
  type = object({
    db_name               = string
    service_username      = string
    service_user_password = string
  })
}

variable "secrets_config" {
  type = object({
    db_urls = object({
      cmk_host            = string
      rds_host            = string
      price_db            = string
      price_user          = string
      price_user_password = string
    })
    docker_registry_credentials = string
    etherscan_api_key           = string
    snowflake_account           = string
  })
}

variable "tsdb_cacert" {
  type = string
}

variable "snowflake_secrets" {
  type = object({
    model_runner = object({
      sf_model_runner_user     = string
      sf_model_runner_password = string
    })

    dbt = object({
      s3_bucket_name                  = string
      snowflake_aws_access_key_id     = string
      snowflake_aws_secret_access_key = string
      dbt_sf_password                 = string
      dbt_sf_user                     = string
    })

    abifetcher = object({
      pipeline_reader_user     = string
      pipeline_reader_password = string
    })

    roles = object({
      sf_reporter_role    = string
      sf_loader_role      = string
      sf_transformer_role = string
    })

    warehouses = object({
      sf_reporting_warehouse    = string
      sf_loading_warehouse      = string
      sf_transforming_warehouse = string
    })

    db = object({
      raw_database      = string
      ethereum_database = string
    })
  })
}
