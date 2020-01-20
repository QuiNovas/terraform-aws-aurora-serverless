
variable "availability_zones" {
  description = "list of avaiability zones for the subnets"
  type        = list(string)
}

variable "cidr_block" {
  description = "The CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/20"
}

variable "name" {
  description = "The name of resources created, used either directly or as a prefix."
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the DB should have a public IP address"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
 default     = ""
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 0
}

variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  type        = bool
  default     = true
}

variable "db_parameter_group_name" {
  description = "The name of a DB parameter group to use"
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_name" {
  description = "The name of a DB Cluster parameter group to use"
  type        = string
  default     = null
}

variable "scaling_configuration" {
  description = "Map of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless`"
  type        = map(string)
  default     = {}
}

variable "snapshot_identifier" {
  description = "DB snapshot to create this database from"
  type        = string
  default     = ""
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

variable "engine" {
  description = "Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql"
  type        = string
}

variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
}

variable "replica_scale_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora (MySQL) read replicas"
  type        = bool
  default     = false
}

variable "replica_scale_max" {
  description = "Maximum number of replicas to allow scaling for"
  type        = number
  default     = 0
}

variable "replica_scale_min" {
  description = "Minimum number of replicas to allow scaling for"
  type        = number
  default     = 2
}

variable "replica_scale_cpu" {
  description = "CPU usage to trigger autoscaling at"
  type        = number
  default     = 70
}

variable "replica_scale_connections" {
  description = "Average number of connections to trigger autoscaling at. Default value is 70% of db.r4.large's default max_connections"
  type        = number
  default     = 700
}

variable "replica_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in"
  type        = number
  default     = 300
}

variable "replica_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out"
  type        = number
  default     = 300
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data."
  type        = string
  default     = ""
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported."
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = []
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier specified on aws_rds_global_cluster"
  type        = string
  default     = ""
}

variable "replication_source_identifier" {
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica."
  default     = ""
}

variable "source_region" {
  description = "The source region for an encrypted replica DB cluster."
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}

variable "predefined_metric_type" {
  description = "The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections."
  default     = "RDSReaderAverageCPUUtilization"
}

variable "backtrack_window" {
  description = "The target backtrack window, in seconds. Only available for aurora engine currently. To disable backtracking, set this value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours)"
  type        = number
  default     = 0
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots."
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "A List of ARNs for the IAM roles to associate to the RDS Cluster."
  type        = list(string)
  default     = []
}

variable "security_group_description" {
  description = "The description of the security group. If value is set to empty string it will contain cluster name in the description."
  type        = string
  default     = "Managed by Terraform"
}

variable "auto_pause" {
  description = "Whether to enable automatic pause. A DB cluster can be paused only when it's idle (it has no connections)."
  type        = bool
  default     = true
}

variable "max_capacity" {
  description = "The maximum capacity. The maximum capacity must be greater than or equal to the minimum capacity"
  type        = number
  default     = 16
}

variable "min_capacity" {
  description = "The minimum capacity. The minimum capacity must be lesser than or equal to the maximum capacity"
  type        = number
  default     = 2
}

variable "seconds_until_auto_pause" {
  description = "the time, in seconds, before an Aurora DB cluster in serverless mode is paused. "
  type        = number
  default     = 300
}

variable "timeout_action" {
  description = "The action to take when the timeout is reached. Valid values: ForceApplyCapacityChange, RollbackCapacityChange."
  type        = string
  default     = "RollbackCapacityChange"
}

variable "install_aws_cli" {
  default     = false
  description = "Installs the AWS CLI module-local. AWS CLI is required to run this module."
  type        = bool
}