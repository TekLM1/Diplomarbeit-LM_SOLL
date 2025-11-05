# EC2_Deployment_Template

## Purpose of use

This template was created to facilitate the deployment of an EC2 instance, with the aim of speeding up the process.
When deploying this template, we must change the variables that correspond to the resources to be created, according to needs

## Resources

All AWS resources are created via terraform.
The EC2 instance is created and the Instance gets the resource that we define on the deploy like the AMi, the instance type, EBS Volume size and type, EC2 Access Key and VPC ID and Subnet ID, Elastic IP Allocation ID for the used EIP and Ingress Rules.

You can find more info regarding this on WIKI just follow this link: Confluence Link

## Instance specifications

OS   - Ubuntu 24.04 LTS
AMI  - ami-0a5237fe4793e04b1
Type - t3.micro

Disk type - gp2\
Disk Size - 50 GB

Account  - Dev1
Location - Zurich (Eu-Central-2)

Key pair assigned - fogbyte_dev1_eu_central_2

Bakcup - lifecycle_DAILY7
Backup - lifecycle_BI_WEEKLY4
