provider "aws" {
  region  = "us-east-1"
  profile = "cloudguru"
}

resource "aws_db_instance" "mysql" {
  identifier          = "mysql-instance"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "exampledb"
  username            = admin
  password            = admin
  publicly_accessible = true
}


# terraform {
#   backend "s3" {
#     bucket         = "contact-me-terraform-state"
#     key            = "stage/data-store/mysql/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt  = true
    
#   }
# }