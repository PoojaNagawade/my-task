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

# Provisioners to install Docker and Jenkins
  provisioner "remote-exec” {
  connection {
      type        = "ssh"
      user        = "ec2-user"  # Update with the appropriate SSH user for your AMI
      private_key = file("~/.ssh/id_rsa")  # Update with the path to your SSH private key
      host = aws_instance.aws_ec2_test.public_ip
    }
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo yum install -y java-1.8.0",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key",
      "sudo yum install -y jenkins",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]
  }

}

# Open port 8080 for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Security group for Jenkins"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name  = "ec2_S3_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}



# Create IAM instance profile and associate with the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = aws_iam_role.ec2_role.name
  role = aws_iam_role.ec2_role.name
}

# Attach policy to IAM role for EC2 instance
resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  # Adjust policy ARN as needed
}


# Create an S3 bucket


resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = "my-jenkins-bucket-azul"  # Replace with your desired bucket name
 # acl    = "public-read"         # Set the ACL to make the bucket publicly readable

  tags = {
    Name = "my-jenkins-bucket"
  }
}

