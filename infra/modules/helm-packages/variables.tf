variable "organization" {
  type        = string
  description = "Name of organization"
  default     = "credmark"
}

variable "argo_controller_replica_count" {
  type        = number
  default     = 2
  description = "Number of replicas to run for argo controller"
}

variable "argo_server_replica_count" {
  type        = number
  default     = 3
  description = "Number of replicas to run for argo server"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "cluster_id" {
  type        = string
  description = "The k8s cluster_id where helm to deploy packages"
}
variable "eks_managed_node_groups_iam_role_arn" {
  type        = string
  description = "The eks_managed_node_groups_iam_role_arn where helm to deploy packages"
}
variable "eks_managed_node_groups_iam_role_name" {
  type        = string
  description = "The eks_managed_node_groups_iam_role_name where helm to deploy packages"
}
variable "eks_oidc_provider_arn" {
  type        = string
  description = "The eks_oidc_provider_arn where helm to deploy packages"
}
variable "cluster_endpoint" {
  type        = string
  description = "The cluster_endpoint for helm_karpenter"
}

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

variable "environment" {
  type        = string
  description = "environment prod or staging"
  validation {
    condition     = contains(["staging", "prod", "staging2" ], var.environment)
    error_message = "The environment must be one of [\"staging\", \"prod\"]."
  }
}

variable "argo_s3_bucket" {
  type        = string
  description = "s3 bucket for argo work flow"
}

variable "acm_arn" {
  type    = string
  default = ""

}
