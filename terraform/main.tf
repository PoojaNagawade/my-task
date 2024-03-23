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

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

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
      "sudo apt install fontconfig openjdk-17-jre -y",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo \"deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install jenkins -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
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

