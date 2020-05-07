resource "aws_rds_cluster" "default" {
  apply_immediately                   = var.apply_immediately
  availability_zones                  = lookup(var.vpc_config, "azs")
  backtrack_window                    = var.backtrack_window
  backup_retention_period             = var.backup_retention_period
  cluster_identifier                  = var.name
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  database_name                       = var.database_name
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  db_subnet_group_name                = module.vpc.database_subnet_group
  deletion_protection                 = var.deletion_protection
  enable_http_endpoint                = var.enable_http_endpoint
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  engine                              = var.engine
  engine_mode                         = "serverless"
  engine_version                      = var.engine_version
  final_snapshot_identifier           = var.final_snapshot_identifier_prefix
  global_cluster_identifier           = var.global_cluster_identifier
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  iam_roles                           = var.iam_roles
  kms_key_id                          = var.kms_key_id
  master_password                     = random_string.random_master_password.result
  master_username                     = var.username
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  replication_source_identifier       = var.replication_source_identifier

  dynamic "scaling_configuration" {
    for_each = length(keys(var.scaling_configuration)) == 0 ? [] : [
    var.scaling_configuration]

    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
    }
  }

  skip_final_snapshot = var.skip_final_snapshot
  snapshot_identifier = var.snapshot_identifier
  source_region       = var.source_region
  storage_encrypted   = var.storage_encrypted

  tags = merge(var.tags, {
    Name = var.name
  })

  vpc_security_group_ids = flatten([aws_security_group.this.id,
    var.vpc_security_group_ids,
  ])
}

resource "random_string" "random_master_password" {
  length           = 31
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "!#$%^&*()_-+="
}