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
  region = "us-west-1"
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

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Update with the appropriate SSH user for your AMI
      private_key = file("~/.ssh/id_rsa")  # Update with the path to your SSH private key
      host        = aws_instance.aws_ec2_test.public_ip
    }

    inline = [
      "sudo apt update -y",
      "sudo apt-get install docker.io -y",
      "sudo apt install default-jre -y",
      "sudo apt-get install python3 -y",
      "sudo apt install fontconfig openjdk-17-jre -y",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo \"deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install jenkins -y",
      "sudo apt-get install wget apt-transport-https gnupg lsb-release -y",
      "wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null",
      "echo \"deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main\" | sudo tee -a /etc/apt/sources.list.d/trivy.list",
      "sudo apt-get update ",
      "sudo apt-get install trivy -y"
    ]
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Security group for Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"  # All protocols
    cidr_blocks     = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.public_bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.public_bucket

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": [
        "arn:aws:s3:::aws_s3_bucket.public_bucket.arn/*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = var.private_bucket_name
  versioning {
      enabled = true
    }
  tags = {
    Name = "My Private Bucket"
  }
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = var.public_bucket_name
  versioning {
      enabled = true
    }
  
  tags = {
    Name = "My Public Bucket"
  }
}
