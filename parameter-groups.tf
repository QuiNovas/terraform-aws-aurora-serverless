## Currently only PostgreSQL 10.7 and MySQL 5.6 Engines are supported #######################
## These are the default parameter groups (postgresql10 and aurora5.6) that may be created ##

resource "aws_db_parameter_group" "aurora_db_postgres_parameter_group" {
  count       = var.db_parameter_group_name == "" && var.engine == "aurora-postgresql" ? 1 : 0
  name        = "aurora-db-postgres10-parameter-group"
  family      = "aurora-postgresql10"
  description = "aurora-db-postgres10-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres_parameter_group" {
  count       = var.db_cluster_parameter_group_name == "" && var.engine == "aurora-postgresql" ? 1 : 0
  name        = "aurora-postgres10-cluster-parameter-group"
  family      = "aurora-postgresql10"
  description = "aurora-postgres10-cluster-parameter-group"
}

resource "aws_db_parameter_group" "aurora_db_mysql_parameter_group" {
  count       = var.db_parameter_group_name == "" && var.engine == "aurora-mysql" ? 1 : 0
  name        = "aurora-db-mysql5-6-parameter-group"
  family      = "aurora5.6"
  description = "aurora-db-mysql5-6-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_mysql_parameter_group" {
  count       = var.db_cluster_parameter_group_name == "" && var.engine == "aurora-mysql" ? 1 : 0
  name        = "aurora-mysql5-6-cluster-parameter-group"
  family      = "aurora5.6"
  description = "aurora-mysql5-6-cluster-parameter-group"
}
