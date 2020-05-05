resource "aws_glue_catalog_database" "default" {
  count = var.glue_etl ? 1 : 0
  name  = aws_rds_cluster.default.database_name
}

resource "aws_glue_connection" "default" {
  count = var.glue_etl ? 1 : 0
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:${var.engine == "aurora-mysql" ? "mysql" : "postgresql"}://${aws_rds_cluster.default.endpoint}:${aws_rds_cluster.default.port}/${aws_rds_cluster.default.database_name}"
    PASSWORD            = random_string.random_masterpassword.result
    USERNAME            = var.username
  }

  name = "${var.name}-glue-connection"

  physical_connection_requirements {
    availability_zone = element(var.azs, 0)
    security_group_id_list = [aws_security_group.this.id,
    ]
    subnet_id = element(module.vpc.private_subnets, 0)
  }
}

resource "aws_glue_crawler" "default" {
  count         = var.glue_etl ? 1 : 0
  configuration = <<CONFIGURATION
  {
   "Version": 1.0,
   "CrawlerOutput": {
    "Partitions": {
      "AddOrUpdateBehavior": "InheritFromTable"
    },
    "Tables": {
      "AddOrUpdateBehavior": "MergeNewColumns"
    }
   }
  }
  
CONFIGURATION
  database_name = aws_glue_catalog_database.default.0.name
  name          = "${var.name}-glue-crawler"
  role          = aws_iam_role.glue_role.0.arn

  jdbc_target {
    connection_name = aws_glue_connection.default.0.name
    path            = "${aws_glue_catalog_database.default.0.name}/%"
  }
  schedule = "cron(0 12 * * ? *)"
}

resource "aws_iam_role" "glue_role" {
  count              = var.glue_etl ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.aws_glue_assume_role.json
  name               = "${var.name}-glue-default"
}

resource "aws_iam_role_policy_attachment" "aws_glue" {
  count      = var.glue_etl ? 1 : 0
  role       = aws_iam_role.glue_role.0.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

data "aws_iam_policy_document" "aws_glue_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = ["glue.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "rds_crawler" {
  statement {
    actions = [
      "rds:*",
    ]

    resources = [
      "*",
    ]

    sid = "AllowRDSAccess"
  }

}

resource "aws_iam_role_policy" "rds_crawler" {
  count  = var.glue_etl ? 1 : 0
  name   = "${var.name}-rds-crawler"
  policy = data.aws_iam_policy_document.rds_crawler.json
  role   = aws_iam_role.glue_role.0.id
}