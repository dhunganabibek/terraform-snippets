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


