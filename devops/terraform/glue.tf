resource "aws_glue_job" "glue_job_raw_to_trusted" {
  name     = "job_raw-to-trusted"
  glue_version = "2.0"
  worker_type = "Standard"
  number_of_workers = 2
  role_arn = "${aws_iam_role.role_glue.arn}"
  depends_on = [aws_s3_bucket.artifacts]

  command {
    script_location = "s3://${aws_s3_bucket.artifacts.id}/raw_to_trusted.py"
  }

  execution_property {
    max_concurrent_runs = 10
  }
}

resource "aws_glue_trigger" "trigger_courses" {
  name = "raw_to_trusted-courses"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.glue_job_raw_to_trusted.name
    arguments = {
      "--FILE_NAME" = "courses.json",
      "--FILE_PATH" = "s3://${aws_s3_bucket.raw.id}/courses.json"
    }
  }
}

resource "aws_glue_trigger" "trigger_sessions" {
  name = "raw_to_trusted-sessions"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.glue_job_raw_to_trusted.name
    arguments = {
      "--FILE_NAME" = "sessions.json",
      "--FILE_PATH" = "s3://${aws_s3_bucket.raw.id}/sessions.json"
    }
  }
}

resource "aws_glue_trigger" "trigger_student_follow_subject" {
  name = "raw_to_trusted-student_follow_subject"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.glue_job_raw_to_trusted.name
    arguments = {
      "--FILE_NAME" = "student_follow_subject.json",
      "--FILE_PATH" = "s3://${aws_s3_bucket.raw.id}/student_follow_subject.json"
    }
  }
}

resource "aws_glue_trigger" "trigger_students" {
  name = "raw_to_trusted-students"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.glue_job_raw_to_trusted.name
    arguments = {
      "--FILE_NAME" = "students.json",
      "--FILE_PATH" = "s3://${aws_s3_bucket.raw.id}/students.json"
    }
  }
}

resource "aws_glue_trigger" "trigger_subjects" {
  name = "raw_to_trusted-subjects"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.glue_job_raw_to_trusted.name
    arguments = {
      "--FILE_NAME" = "subjects.json",
      "--FILE_PATH" = "s3://${aws_s3_bucket.raw.id}/subjects.json"
    }
  }
}

resource "aws_glue_trigger" "trigger_subscriptions" {
  name = "raw_to_trusted-subscriptions"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.glue_job_raw_to_trusted.name
    arguments = {
      "--FILE_NAME" = "subscriptions.json",
      "--FILE_PATH" = "s3://${aws_s3_bucket.raw.id}/subscriptions.json"
    }
  }
}

resource "aws_glue_trigger" "trigger_universities" {
  name = "raw_to_trusted-universities"
  type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.glue_job_raw_to_trusted.name
    arguments = {
      "--FILE_NAME" = "universities.json",
      "--FILE_PATH" = "s3://${aws_s3_bucket.raw.id}/universities.json"
    }
  }
}