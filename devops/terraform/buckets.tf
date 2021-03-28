resource "aws_s3_bucket" "raw" {
  bucket = "passei-direto-datalake-raw-zone"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}

resource "aws_s3_bucket" "trusted" {
  bucket = "passei-direto-datalake-trusted-zone"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}

resource "aws_s3_bucket" "refined" {
  bucket = "passei-direto-datalake-refined-zone"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "passei-direto-datalake-artifacts-zone"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}

resource "null_resource" "s3_sync_objects" {
  provisioner "local-exec" {
    command = format("aws s3 sync ../../jobs/glue-spark-jobs/ s3://passei-direto-datalake-artifacts-zone/ --profile %s", var.profile_aws_cli)
  }

  depends_on = [aws_s3_bucket.artifacts]
}