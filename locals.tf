locals {
  db_parameter_group_name         = (var.db_parameter_group_name == "" && var.engine == "aurora-postgresql") ? aws_db_parameter_group.aurora_db_postgres_parameter_group.0.id : (var.db_parameter_group_name == "" && var.engine == "aurora-mysql") ? aws_db_parameter_group.aurora_db_mysql_parameter_group.0.id : var.db_parameter_group_name
  db_cluster_parameter_group_name = (var.db_cluster_parameter_group_name == "" && var.engine == "aurora-postgresql") ? aws_rds_cluster_parameter_group.aurora_cluster_postgres_parameter_group.0.id : (var.db_cluster_parameter_group_name == "" && var.engine == "aurora-mysql") ? aws_rds_cluster_parameter_group.aurora_cluster_mysql_parameter_group.0.id : var.db_cluster_parameter_group_name
  port                            = var.engine == "aurora-postgresql" ? "5432" : "3306"
}
