resource "aws_glue_catalog_database" "default" {
  name = aws_rds_cluster.default.cluster_identifier
}

resource "aws_glue_connection" "default" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:${var.engine}://${aws_rds_cluster.default.endpoint}/${aws_glue_catalog_database.aws_glue_catalog_database.name}"
    PASSWORD            = random_string.random_dbpassword.result
    USERNAME            = var.username
  }

  name = "glue-connection"

  physical_connection_requirements {
    availability_zone      = aws_subnet.private.availability_zone
    security_group_id_list = aws_security_group.base_sg.id
    subnet_id              = aws_subnet.private.id
  }
}



resource "aws_glue_crawler" "default" {
  database_name = aws_glue_catalog_database.default.name
  name          = "glue-crawler"
  role          = aws_iam_role.example.arn

  jdbc_target {
    connection_name = "${aws_glue_connection.example.name}"
    path            = "database-name/%"
  }
}


resource "random_string" "random_dbpassword" {
  length           = 31
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "!@#$%^&*()_-+="
}

resource "aws_iam_role" "glue_role" {
  assume_role_policy = data.aws_iam_policy_document.aws_glue_assume_role.json
  name               = "glue-default"
}

resource "aws_iam_role_policy_attachment" "aws_glue_thynkhealth" {
  role       = aws_iam_role.glue_role.id
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

    sid = "AllowReadwriteAccess"
  }

}