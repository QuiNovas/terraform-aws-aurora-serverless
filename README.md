# terraform-aws-aurora-serverless

This module is used to create serverless aws aurora cluster with either aurora-mysql or aurora-postgresql as database engine. 

This module creates a VPC. Atleast 3 subnet CIDR's need to be passed in, to create private subnets with no internet access to and fro.

**Note:**
Currently Postgresql 10.7 and MySQL 5.6.10a are only specific engine versions supported for serverless.

## Usage

```hcl
module "aurora_serverless" {
  allowed_security_groups = ["sg-083a4322855cb3f6f"]
  apply_immediately       = true
  database_name           = "foobar"
  engine                  = "aurora-postgresql"
  engine_version          = "10.7"
  monitoring_interval     = 10
  name                    = "test-postgresql"
  replica_scale_enabled   = false

  scaling_configuration = {
    auto_pause               = false
    max_capacity             = 16
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }

  skip_final_snapshot = true
  storage_encrypted   = true
  source              = "Quinovas/aurora-serverless/aws"

  tags = {
    Terraform = true
    Purpose   = "RDS Aurora Serverless Cluster"
  }

  vpc_config = {
    azs              = slice(data.aws_availability_zones.current.names, 0, 3)
    cidr_block       = "10.0.0.0/16"
    database_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  vpc_security_group_ids = ["sg-074f385d08f152856"]
}

data "aws_availability_zones" "current" {
  state = "available"
}
```

## Authors

Module is maintained by [QuiNovas](https://github.com/QuiNovas)

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/). See LICENSE for full details.