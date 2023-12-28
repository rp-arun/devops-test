locals {
  namespace                          = "ingress-nginx"
  ingress_nginx_service_account_name = "ingress-nginx-controller"
  cluster_id                         = var.cluster_id
  eks_oidc_provider_arn              = var.eks_oidc_provider_arn

}

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = local.namespace
  }
}

module "ingress_nginx_irsa" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "4.17.1"
  attach_load_balancer_controller_policy = true
  role_name                              = "${local.ingress_nginx_service_account_name}-${local.cluster_id}"
  depends_on = [
    kubernetes_namespace.ingress_nginx
  ]
  oidc_providers = {
    ex = {
      provider_arn               = local.eks_oidc_provider_arn
      namespace_service_accounts = ["${local.namespace}:${local.ingress_nginx_service_account_name}"]
    }
  }
}


resource "kubernetes_service_account" "ingress_nginx_controller" {
  depends_on = [
    module.ingress_nginx_irsa
  ]
  metadata {
    name      = local.ingress_nginx_service_account_name
    namespace = local.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.ingress_nginx_irsa.iam_role_arn
    }
  }
}

resource "helm_release" "ingress_nginx" {
  namespace        = local.namespace
  create_namespace = false
  force_update     = true
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"

  depends_on = [
    kubernetes_service_account.ingress_nginx_controller
  ]

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Cluster"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "tcp"
    #value = var.environment == "prod" ? "http" : "tcp"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
  }

//serviceMonitor
  # set {
  #   name  = "controller.metrics.enabled"
  #   value = true
  # }

  # set {
  #   name  = "controller.metrics.serviceMonitor.enabled"
  #   value = true
  # }

  # set {
  #   name  = "controller.metrics.serviceMonitor.additionalLabels.release"
  #   value = "prometheus"
  # }
//
  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = local.ingress_nginx_service_account_name
  }

  # set {
  #   name  = var.environment == "prod" ? "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert" : ""
  #   value = var.environment == "prod" ? var.acm_arn : ""
  # }

  # set {
  #   name  = var.environment == "prod" ? "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports" : ""
  #   value = var.environment == "prod" ? "https" : ""
  # }

  # set {
  #   name  = var.environment == "prod" ? "controller.service.targetPorts.https" : ""
  #   value = var.environment == "prod" ? "http" : ""
  # }

  # set {
  #   name  = var.environment == "prod" ? "controller.config.use-forwarded-headers" : ""
  #   value = var.environment == "prod" ? "true" : ""
  # }

  set {
    name  =  "controller.config.proxy-body-size"
    value =  "10m"
  }

  set {
    name  =  "controller.config.proxy-read-timeout"
    value =  "1800s"
  }

  # Ensure the ELB idle timeout is less than nginx keep-alive timeout. By default,
  # NGINX keep-alive is set to 75s. If using WebSockets, the value will need to be
  # increased to '3600' to avoid any potential issues.
  
  set {
    name  = var.environment == "prod" ? "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout" : ""
    value = var.environment == "prod" ? "1800" : ""
  }

# Tolerations
  set {
      name  = "controller.tolerations[0].key"
      value = "node"
  }
  set {
      name  = "controller.tolerations[0].value"
      value = "ingress"
  }
  set {
      name  = "controller.tolerations[0].operator"
      value = "Equal"
  }
  set {
      name  = "controller.tolerations[0].effect"
      value = "NoSchedule"
  }
  # https://stackoverflow.com/questions/52669058/setting-nested-data-structures-from-helm-command-line/52710471#52710471
  
  set {
      name  = "controller.nodeSelector.node"
      value = "ingress"
  }
}
