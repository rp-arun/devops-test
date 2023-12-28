output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "SUBNET IDS."
  value       = module.vpc.private_subnets
}

output "vpc_cidr_block" {
  description = "vpc_cidr_block for rds security group"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "SUBNET IDS."
  value       = module.vpc.public_subnets
}