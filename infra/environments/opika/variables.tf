variable "AWS_EKS_ADMIN_ROLE_ARN" {
  type        = string
  default = "arn:aws:iam::599441073426:role/eks-admin"
  description = "aws provider assume role arn"
}
