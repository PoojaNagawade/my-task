This project aims to automate the process of downloading data from a free data provider, extracting specific information, storing it in cloud storage, and presenting it using a simple HTML page. 

# Overview
The project follows these main steps:

Data Download: Regularly download dataset from a chosen free data provider (e.g., Coinbase API or OpenWeatherMap).

Data Extraction: Extract specific data from the downloaded dataset, such as information relevant to Czechia or Prague.

Storage: Store the extracted data securely in cloud storage (AWS S3).

HTML Page Generation: Generate a simple HTML page to display the extracted data in a tabular format.

Automation: Utilize Terraform for automated provisioning of cloud resources and Jenkins for continuous integration and deployment.

# Technologies Used
Python: Scripting language for data extraction and manipulation.
Docker: Containerization tool to package the application and its dependencies.
Terraform: Infrastructure as Code tool for provisioning cloud resources.
Jenkins: Automation server for continuous integration and deployment.
AWS S3: Cloud storage service for storing the extracted data and HTML page.


