provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Env" : "prod"
      "Region" : "us-east-1"
      "managed_by" : "RenanCoradini/Terraform/Terragrunt"

    }
  }
}
resource "aws_dynamodb_table" "statelock" {
  name         = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "bucketdenzel" {
  bucket = "bucketdenzel-testenumber3"
}

resource "aws_s3_bucket_versioning" "versioning_bucketdenzel" {
  bucket = aws_s3_bucket.bucketdenzel.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucketdenzel.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"

    }
    bucket_key_enabled = true
  }
}

output "s3_bucket_id" {
  description = "The ARN of the created S3 bucket."
  value       = aws_s3_bucket.bucketdenzel.id

}
output "dynamo_db_name" {
  description = "The ARN of the created S3 bucket."
  value       = aws_dynamodb_table.statelock.name
}
