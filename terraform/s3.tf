resource "aws_s3_bucket" "motion_videos" {
  bucket = var.bucket_name
  acl = "private"

  lifecycle_rule {
    id = "cleanup"
    enabled = true
    expiration {
      days = 90
    }
  }
}

variable "bucket_name" {
  type = string
}
