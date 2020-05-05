output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_arns" {
  value = module.vpc.public_subnet_arns
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnet_arns" {
  value = module.vpc.private_subnet_arns
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_arn" {
  value = aws_rds_cluster.default.arn
}

output "cluster_id" {
  value = aws_rds_cluster.default.id
}

output "rds_instance_endpoint" {
  value = aws_rds_cluster.default.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.default.reader_endpoint
}

output "database_name" {
  value = aws_rds_cluster.default.database_name
}

output "database_master_username" {
  value = aws_rds_cluster.default.master_username
}

output "database_master_password" {
  value = random_string.random_masterpassword.result
}

output "hosted_zone_id" {
  value = aws_rds_cluster.default.hosted_zone_id
}

output "port" {
  value = aws_rds_cluster.default.port
}

output "security_group_id" {
  value = aws_security_group.this.id
}
