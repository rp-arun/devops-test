variable "argocd_config" {
  type = object({
    sso = object({
      github_client_id     = string
      github_client_secret = string
      allowed_team         = string
      github_org           = string
    })
    githubAppID = string
    githubAppInstallationID = string
    githubAppPrivateKey = string
  })
}

variable "argo_workflow_sso_config" {
  type = object({
    redirect_url = string
    secret_name  = string
    secret_data = object({
      client-id     = string
      client-secret = string
    })
  })
}


variable "base_domain" {
  type        = string
  description = "The argocd base url"
}

variable "path" {
  type        = string
  description = "The path of argocd"
}

variable "environment" {
  type        = string
  description = "environment prod or staging"
  validation {
    condition     = contains(["staging", "prod", "staging2" ], var.environment)
    error_message = "The environment must be one of [\"staging\", \"prod\"]."
  }
}