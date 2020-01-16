resource "null_resource" "install_aws_cli" {
  provisioner "local-exec" {
    command = <<EOH
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "${path.module}/awscli-bundle.zip"; unzip ${path.module}/awscli-bundle.zip -d ${path.module}; ${path.module}/awscli-bundle/install -b ~/bin/aws;
EOH

  }
}