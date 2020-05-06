module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = "${var.name}-vpc"

  cidr = lookup(var.vpc_config, "cidr_block")

  azs             = lookup(var.vpc_config, "azs")
  private_subnets = lookup(var.vpc_config, "private_subnets")
  public_subnets  = lookup(var.vpc_config, "public_subnets")

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = var.tags
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-cluster"
  subnet_ids = module.vpc.private_subnets
  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  vpc_id      = module.vpc.vpc_id

  description = "Control in/out Traffic RDS Aurora ${var.name}"

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_security_group_rule" "default_ingress" {
  count                    = length(var.allowed_security_groups)
  description              = "From allowed SGs"
  type                     = "ingress"
  from_port                = aws_rds_cluster.default.port
  to_port                  = aws_rds_cluster.default.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "cidr_ingress" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description = "From allowed CIDRs"

  type              = "ingress"
  from_port         = aws_rds_cluster.default.port
  to_port           = aws_rds_cluster.default.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this.id
}