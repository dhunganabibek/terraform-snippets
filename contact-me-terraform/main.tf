provider "aws" {
  region = "us-east-1"
  profile = "cloudguru"
}


resource  "aws_s3_bucket" "contact_me_terraform_state" {
    bucket = "contact-me-terraform-state"

    // to prevent accidental deletion of the bucket
    lifecycle {
      prevent_destroy = true
    }
}


# add versioning to the bucket
resource "aws_s3_bucket_versioning" "contact_me_terraform_state_versioning" {
  bucket = aws_s3_bucket.contact_me_terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# applyiG server side encryption to the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "contact_me_terraform_state_encryption" {
  bucket = aws_s3_bucket.contact_me_terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# make the bucket super secure by restricting public access
resource "aws_s3_bucket_public_access_block" "contact_me_terraform_state_public_access_block" {
  bucket = aws_s3_bucket.contact_me_terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# creating a DynamoDB table to be used as a state lock
resource "aws_dynamodb_table" "contact_me_terraform_state_lock" {
  name         = "contact-me-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  // to prevent accidental deletion of the table
  lifecycle {
    prevent_destroy = true
  }
}


# setting up the backend for Terraform to use the S3 bucket and DynamoDB table
terraform {
  backend "s3" {
    bucket         = "contact-me-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "contact-me-terraform-state-lock"
    encrypt       = true
    
  }
}


# setting up the output for the S3 bucket and DynamoDB table
output "s3_bucket_name" {
  value = aws_s3_bucket.contact_me_terraform_state.id
  description = "The name of the S3 bucket used for Terraform state"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.contact_me_terraform_state_lock.name
  description = "The name of the DynamoDB table used for Terraform state locking"
}