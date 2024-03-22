terraform {
 required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.16"
}
}
        required_version = ">= 1.2.0"
}


provider "aws" {
region = "us-east-2"
}


resource "aws_key_pair" "key" {
  key_name   = "id_rsa" 
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "aws_ec2_test" {
 ami = "ami-0b8b44ec9a8f90422"
 instance_type = "t2.micro"
# refering key which we created earlier
  key_name = aws_key_pair.key.key_name
  iam_instance_profile = aws_iam_role.ec2_role.name
  tags = {
        Name = "TerraformTestServerInstance"
      }
}


# Create an S3 bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "data-downloads"  # Replace with your desired private bucket name
  acl    = "private"             # Set the ACL to private

  tags = {
    Name = "My Private Bucket"
  }
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "filtered-output"    # Replace with your desired public bucket name
  acl    = "public-read"         # Set the ACL to public-read

  tags = {
    Name = "My Public Bucket"
  }
}

