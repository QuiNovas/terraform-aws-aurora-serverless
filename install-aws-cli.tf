resource "null_resource" "install_aws_cli" {
  count = var.install_aws_cli ? 1 : 0
  provisioner "local-exec" {
    command = <<EOH
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "${path.module}/awscli-bundle.zip" \
&& unzip ${path.module}/awscli-bundle.zip -d ${path.module} \
&& sudo ${path.module}/awscli-bundle/install -i ${path.module}/awscli
EOH

  }
  triggers = {
    cluster_id = aws_rds_cluster.default.id
  }
}