resource "aws_glue_job" "test_glue_job" {
  name     = "job1"
  role_arn = "${aws_iam_role.role_glue.arn}"
  depends_on = [aws_s3_bucket.artifacts]

  command {
    script_location = "s3://${aws_s3_bucket.artifacts.id}/raw_to_trusted.py"
  }
}