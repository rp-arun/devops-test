variable "cluster_id" {
  type        = string
  description = "The k8s cluster_id where helm to deploy packages"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "The eks_oidc_provider_arn where helm to deploy packages"
}

variable "environment" {
  type        = string
  description = "environment prod or staging"
  validation {
    condition     = contains(["staging", "prod", "staging2"], var.environment)
    error_message = "The environment must be one of [\"staging\", \"prod\"]."
  }
}

variable "acm_arn" {
  type    = string
  default = ""
}

