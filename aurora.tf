resource "aws_rds_cluster" "default" {
  cluster_identifier                  = "${var.name}-cluster"
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  database_name                       = var.database_name
  deletion_protection                 = var.deletion_protection
  master_password                     = random_string.random_masterpassword.result
  master_username                     = var.username
  final_snapshot_identifier           = var.final_snapshot_identifier_prefix
  skip_final_snapshot                 = var.skip_final_snapshot
  availability_zones                  = random_shuffle.az.result
  backtrack_window                    = var.backtrack_window
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  vpc_security_group_ids              = flatten([aws_security_group.base_sg.id,
                                         var.vpc_security_group_ids,
  ])
  snapshot_identifier                 = var.snapshot_identifier
  global_cluster_identifier           = var.global_cluster_identifier
  storage_encrypted                   = var.storage_encrypted
  replication_source_identifier       = var.replication_source_identifier
  apply_immediately                   = var.apply_immediately
  db_subnet_group_name                = aws_db_subnet_group.default.id
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  kms_key_id                          = var.kms_key_id
  iam_roles                           = var.iam_roles
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  engine                              = var.engine
  engine_mode                         = "serverless"
  scaling_configuration {
    auto_pause               = var.auto_pause
    max_capacity             = var.max_capacity
    min_capacity             = var.min_capacity
    seconds_until_auto_pause = var.seconds_until_auto_pause
    timeout_action           = var.timeout_action
  }
  engine_version                  = var.engine_version
  source_region                   = var.source_region
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = var.tags

}


resource "random_string" "random_masterpassword" {
  length           = 31
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "!#$%^&*()_-+="
}


resource "null_resource" "update_aurora_cluster" {
  depends_on = [null_resource.install_aws_cli]

  provisioner "local-exec" {
    command = "${local.aws_cli_command} rds modify-db-cluster --db-cluster-identifier ${aws_rds_cluster.default.id} --enable-http-endpoint"
  }
}