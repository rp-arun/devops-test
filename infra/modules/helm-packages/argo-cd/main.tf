locals {
  git_secret_name  = "git-credentials"
  ops_repo_url     = "https://github.com/credmark-devops/gitops.git"
  argocd_host      = var.base_domain
  argocd_path      = var.path
  sso_allowed_team = var.argocd_config.sso.allowed_team
  sso_github_org   = var.argocd_config.sso.github_org
  helm_secret_name = "helm-credentials"
  helm_repo_url    = "https://raw.githubusercontent.com/credmark-devops/gitops/main/helm/build/"
  base_domain      = var.environment == "prod" ? "credmark.com" : "${var.environment}.credmark.com"
}

resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret" "git_credentials" {
  metadata {
    name      = local.git_secret_name
    namespace = kubernetes_namespace.argo_cd.metadata[0].name
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type                    = "git"
    url                     = local.ops_repo_url
    project                 = "default"
    githubAppID             = var.argocd_config.githubAppID
    githubAppInstallationID = var.argocd_config.githubAppInstallationID
    githubAppPrivateKey     = var.argocd_config.githubAppPrivateKey

  }

  depends_on = [
    resource.kubernetes_namespace.argo_cd
  ]
}

resource "kubernetes_secret" "argo_workflow_sso" {
  metadata {
    name      = var.argo_workflow_sso_config.secret_name
    namespace = kubernetes_namespace.argo_cd.metadata[0].name
  }

  data = var.argo_workflow_sso_config.secret_data
  depends_on = [
    resource.kubernetes_namespace.argo_cd
  ]
}

data "template_file" "argocd_values" {
  template = file("${path.module}/values.yml")
  vars = {
    HOST                            = local.argocd_host
    PATH                            = local.argocd_path
    SSO_GITHUB_CLIENT_ID            = var.argocd_config.sso.github_client_id
    SSO_GITHUB_CLIENT_SECRET        = var.argocd_config.sso.github_client_secret
    SSO_ALLOWED_TEAM                = local.sso_allowed_team
    SSO_GITHUB_ORG                  = local.sso_github_org
    ARGO_WORKFLOWS_SSO_SECRET_NAME  = var.argo_workflow_sso_config.secret_name
    ARGO_WORKFLOWS_SSO_CLIENT_ID    = "${var.argo_workflow_sso_config.secret_data.client-id}"
    ARGO_WORKFLOWS_SSO_REDIRECT_URL = var.argo_workflow_sso_config.redirect_url
    GRAFANA_SSO_REDIRECT_URL        = "https://gf.${local.base_domain}/login/generic_oauth"
    #GITHUB_TOKEN                    = var.argocd_config.git_password
    HELM_REPO_URL                   = local.helm_repo_url
    GRAFANA_CLIENT_ID               = "grafana-sso-${var.environment}"
    GRAFANA_CLIENT_SECRET           = "grafana-secret-${var.environment}"
  }
}

resource "helm_release" "argo_cd" {
  name      = "argo-cd"
  namespace = kubernetes_namespace.argo_cd.metadata[0].name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  values = [
    data.template_file.argocd_values.rendered
  ]
  depends_on = [
    resource.kubernetes_secret.git_credentials
  ]
}

# resource "kubernetes_secret" "helm_repo_credentials" {
#   metadata {
#     name      = local.helm_secret_name
#     namespace = kubernetes_namespace.argo_cd.metadata[0].name
#   }
#   data = {
#     name = "cmk"
#     type     = "helm"
#     url      = local.helm_repo_url
#     username = var.argocd_config.git_password
#     password = var.argocd_config.git_password
#   }

#   depends_on = [
#     resource.kubernetes_namespace.argo_cd
#   ]
# }
