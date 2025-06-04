provider "aws" {
  region  = "us-east-1"
  profile = "cloudguru"
}

# creating new aws ec2 instance
resource "aws_instance" "vm"{
    ami = "ami-0f1a6835595fb9246"
    instance_type = "t2.micro"
}