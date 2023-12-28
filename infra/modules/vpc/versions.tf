terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/null/latest
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    # https://registry.terraform.io/providers/hashicorp/template/latest
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    # https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.10"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~>3.0"
    }

  }

  required_version = "~> 1.3.5"
}
