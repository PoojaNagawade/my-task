This project aims to automate the process of downloading data from a free data provider, extracting specific information, storing it in cloud storage, and presenting it using a simple HTML page. 

# Overview
The project follows these main steps:

Data Download: Regularly download dataset from a chosen free data provider (e.g., Coinbase API or OpenWeatherMap).

Data Extraction: Extract specific data from the downloaded dataset, such as information relevant to Czechia or Prague.

Storage: Store the extracted data securely in cloud storage (AWS S3).

HTML Page Generation: Generate a simple HTML page to display the extracted data in a tabular format will be served by AWS S3.

Automation: The first step is to use Terraform to provision the necessary infrastructure on AWS. We'll define Terraform scripts to create EC2 instances with Docker ,Python ,Java  and Jenkins installed. This infrastructure will serve as the environment for our automation process and Jenkins for continuous integration and deployment.

# Technologies Used
Python: Scripting language for data extraction and manipulation.
Docker: Containerization tool to package the application and its dependencies.
Docker Hub :For storing the Docker image .
Terraform: Infrastructure as Code tool for provisioning cloud resources.
Jenkins: Automation server for continuous integration and deployment.
AWS S3: Cloud storage service for storing the extracted data and HTML page.


# Steps:
1.Configure AWS CLI in your machine .
2.Install terraform .
3.Clone the project .
4.Run the terraform main.tf script 
  terraform init 
  terraform plan -var-file=filename 
  terraform apply -var-file=filename
5.Once the EC2 is up define IAM role to have s3 Full access 
6.Jenkins ,Docker ,Python is already installed via Terraform 
7.start the jenkins server .
8.Run the jenkins pipeline .
9.The output will be stored in s3 bucket .
  
# Output
https://mytask-output.s3.us-west-1.amazonaws.com/data_20240323_180236.html

