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

variable "key_name" {
  description = "Name for the AWS key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  type        = string
}

variable "private_bucket_name" {
  description = "Name for the private S3 bucket"
  type        = string
}

variable "public_bucket_name" {
  description = "Name for the public S3 bucket"
  type        = string
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "aws_ec2_test" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key.key_name
  
  tags = {
    Name = var.instance_name
  }
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = var.private_bucket_name
  
  tags = {
    Name = "My Private Bucket"
  }
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = var.public_bucket_name
  
  tags = {
    Name = "My Public Bucket"
  }
}

