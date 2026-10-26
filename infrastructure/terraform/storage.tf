resource "aws_s3_bucket" "mia_friends" {
  bucket_prefix = "alive-ai-voice-friends-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "mia_friends" {
  bucket = aws_s3_bucket.mia_friends.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mia_friends" {
  bucket = aws_s3_bucket.mia_friends.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}