module "aurora_serverless_master_credentials" {
  description = "RDS database root credentials for ${var.name}"
  name        = "rds-db-credentials/${aws_rds_cluster.default.id}"
  value       = jsonencode({ "password" = random_string.random_master_password.result, "username" = var.username, "engine" = var.engine, "host" = aws_rds_cluster.default.endpoint, "port" = local.port, "dbClusterIdentifier" = aws_rds_cluster.default.id })
  source      = "QuiNovas/standard-secret/aws"
  version     = "3.0.1"
}