variable "environment" {
  type        = string
  description = "environment prod or staging"
  validation {
    condition     = contains(["staging", "prod", "staging2" ], var.environment)
    error_message = "The environment must be one of [\"staging\", \"prod\"]."
  }
}
