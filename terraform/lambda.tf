resource "aws_iam_role" "lambda_iam" {
  name = "lambda_iam"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "ses_access" {
  name = "ses_access"
  role = aws_iam_role.lambda_iam.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "ses:SendEmail"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "s3_trigger" {
  name = "s3_trigger"
  role = aws_iam_role.lambda_iam.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:ListBucket"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_iam.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_function" "upload_trigger_lambda" {
  filename      = "../lambda.zip"
  function_name = "motion_video_trigger"
  role          = aws_iam_role.lambda_iam.arn
  handler       = "lambda.run"
  source_code_hash = filebase64sha256("../lambda.zip")
  runtime = "python3.7"
  environment {
    variables = {
      toEmail = var.lambda_to_email
      fromEmail = var.lambda_from_email
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_trigger_lambda" {
  bucket = aws_s3_bucket.motion_videos.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.upload_trigger_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "s3_put_trigger" {
  statement_id = "AllowTriggerFromS3"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_trigger_lambda.arn
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.motion_videos.arn
}

variable "lambda_to_email" {
  type = string
}

variable "lambda_from_email" {
  type = string
}
