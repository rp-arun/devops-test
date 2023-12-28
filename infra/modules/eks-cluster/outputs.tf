# output "region" {
#   description = "AWS region."
#   value       = var.region
# }

# output "cluster_id" {
#   description = "EKS cluster ID."
#   value       = module.eks.cluster_id
# }

# output "cluster_endpoint" {
#   description = "Endpoint for EKS control plane."
#   value       = module.eks.cluster_endpoint
# }

# output "eks_managed_node_groups_iam_role_arn" {
#   value       = module.eks.eks_managed_node_groups["workflows"].iam_role_arn
#   description = "EKS managed node goups IAM role ARN"
# }

# output "eks_managed_node_groups_iam_role_name" {
#   value       = module.eks.eks_managed_node_groups["workflows"].iam_role_name
#   description = "EKS managed node goups IAM role ARN"
# }

# output "eks_oidc_provider_arn" {
#   value       = module.eks.oidc_provider_arn
#   description = "EKS OIDC provider ARN"
# }

# output "cluster_certificate_authority_data" {
#   value = module.eks.cluster_certificate_authority_data
# }
