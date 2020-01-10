output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
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
  value = aws_rds_cluster.default.master_username
}

output "hosted_zone_id" {
  value = aws_rds_cluster.default.hosted_zone_id
}

