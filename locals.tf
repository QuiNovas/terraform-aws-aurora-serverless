locals {
  port                                = var.engine == "aurora-postgresql" ? "5432" : "3306"
  cidr_block                          = var.cidr_block
  aws_cli_command                     = "~/bin/aws"
  private_subnet_base_ipv4_cidr_block = cidrsubnet(local.cidr_block, 1, 1)
  public_subnet_base_ipv4_cidr_block  = cidrsubnet(local.cidr_block, 1, 0)
  private_subnets = [
    cidrsubnet(local.private_subnet_base_ipv4_cidr_block, 3, 0),
    cidrsubnet(local.private_subnet_base_ipv4_cidr_block, 3, 1),
    cidrsubnet(local.private_subnet_base_ipv4_cidr_block, 3, 2),
  ]
  public_subnets = [
    cidrsubnet(local.public_subnet_base_ipv4_cidr_block, 3, 3),
  ]
  subnets_count = 3
}
