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
resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = "my-jenkins-bucket-azul"  # Replace with your desired bucket name
 # acl   = "public-read"         # Set the ACL to make the bucket publicly readable

  tags = {
    Name = "my-jenkins-bucket"
  }
}

