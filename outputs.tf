output "vpc_arn" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_id" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_id
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "database_subnet_group" {
  description = "Database subnet group id"
  value       = module.vpc.database_subnet_group
}

output "cluster_arn" {
  description = "Cluster ARN"
  value       = aws_rds_cluster.default.arn
}

output "cluster_id" {
  description = "Cluster ID"
  value       = aws_rds_cluster.default.id
}

output "rds_instance_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.default.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.default.reader_endpoint
}

output "database_name" {
  description = "Name of the database created on cluster creation"
  value       = aws_rds_cluster.default.database_name
}

output "database_master_username" {
  description = "Master Username"
  value       = aws_rds_cluster.default.master_username
}

output "database_master_password" {
  description = "Master password"
  value       = random_string.random_masterpassword.result
}

output "hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = aws_rds_cluster.default.hosted_zone_id
}

output "port" {
  description = "Database port"
  value       = aws_rds_cluster.default.port
}

output "security_group_id" {
  description = "The SG of the cluster"
  value       = aws_security_group.this.id
}