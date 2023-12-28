locals {
  path = var.environment == "prod" ? "prod" : "${var.environment}"
}

data "template_file" "deployment_manifest_values" {
  template = file("${path.module}/appsets/deployment_appset_manifest.yaml")
  vars = {
    PATH = local.path
  }
}

resource "kubectl_manifest" "deployment_appset" {
  yaml_body = data.template_file.deployment_manifest_values.rendered
}

data "template_file" "grafana_manifest_values" {
  template = file("${path.module}/appsets/grafana_appset.yaml")
  vars = {
    PATH = local.path
  }
}

resource "kubectl_manifest" "grafana_appset" {
  yaml_body = data.template_file.grafana_manifest_values.rendered
}

data "template_file" "workflows_manifest_values" {
  template = file("${path.module}/appsets/workflows_appset.yaml")
  vars = {
    PATH = local.path
  }
}

resource "kubectl_manifest" "workflows_appset" {
  yaml_body = data.template_file.workflows_manifest_values.rendered
}

data "template_file" "misc_k8s_values" {
  template = file("${path.module}/appsets/misc_k8s_appset.yaml")
  vars = {
    PATH = local.path
  }
}

resource "kubectl_manifest" "misc_k8s_appset" {
  yaml_body = data.template_file.misc_k8s_values.rendered
}

data "template_file" "sops_secrets_values" {
  template = file("${path.module}/appsets/sops_secret_appset.yaml")
  vars = {
    PATH = local.path
  }
}

resource "kubectl_manifest" "sops_secrets" {
  yaml_body = data.template_file.sops_secrets_values.rendered
}