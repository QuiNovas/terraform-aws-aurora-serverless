locals {
  port = var.engine == "aurora-postgresql" ? "5432" : "3306"
}
