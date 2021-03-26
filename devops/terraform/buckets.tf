resource "aws_s3_bucket" "raw" {
  bucket = "passei-direto-datalake-raw-zone"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}

resource "aws_s3_bucket" "trusted" {
  bucket = "passei-direto-datalake-raw-trusted"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}

resource "aws_s3_bucket" "refined" {
  bucket = "passei-direto-datalake-raw-refined"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "passei-direto-datalake-raw-artifacts"
  acl    = "private"

  tags = {
    Name        = "desafio-pd"
  }
}