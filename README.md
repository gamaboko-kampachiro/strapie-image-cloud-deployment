# Task-4: Terraform Deployment of Private EC2 Instance with Strapi

This project demonstrates a complete Terraform implementation for deploying a private EC2 instance running Strapi in a secure AWS VPC environment with public and private subnets.

## Architecture Overview

This solution implements a secure, multi-tier architecture:
- VPC with public and private subnets across multiple availability zones
- Private EC2 instance running Strapi in a private subnet
- NAT Gateway for outbound internet access from private subnet
- Security groups for granular access control
- SSH key pair for secure access to the EC2 instance
- Application Load Balancer in public subnet for external access to the Strapi application
- Automated installation of Docker and Strapi via user_data scripts

Internet
|
Application Load Balancer (Public Subnet)
|
Target Group
|
Private EC2 (Dockerized Strapi)
|
NAT Gateway
|
Internet Gateway

## Loom Vedio Link
https://www.loom.com/share/7d9e03be72934d96a959818002340145


---

## 🛠️ Technologies Used

- **AWS**
  - VPC
  - EC2
  - Application Load Balancer
  - NAT Gateway
  - Internet Gateway
  - Security Groups
- **Terraform** (Infrastructure as Code)
- **Docker**
- **Strapi (Headless CMS)**
- **Amazon Linux 2**

---

## 📁 Project Structure

terraform-strapi/
├── alb.tf # Application Load Balancer resources
├── ec2.tf # EC2 instance and AMI
├── outputs.tf # Terraform outputs
├── provider.tf # AWS provider
├── security.tf # Security Groups
├── terraform.tfvars # Environment-specific values
├── user_data.sh # Docker + Strapi bootstrap script
├── variables.tf # Input variables
├── vpc.tf # VPC, subnets, routes, NAT
├── .gitignore
└── README.md

---

## Features

### 1. Secure VPC Architecture
- **Public Subnets**: Host the Application Load Balancer for internet-facing traffic
- **Private Subnets**: Host the EC2 instance running Strapi with no direct internet access
- **Multiple Availability Zones**: Ensures high availability of the infrastructure

### 2. Network Address Translation (NAT) Gateway
- Enables private EC2 instances to connect to the internet or AWS services
- Blocks inbound traffic from the internet to private instances
- Provides secure outbound connectivity for updates and external API calls

### 3. Access Control
- **Security Groups**: Fine-grained firewall rules for inbound and outbound traffic
- **SSH Key Pair**: Secure authentication for accessing the EC2 instance
- **Load Balancer**: Acts as the single entry point for application traffic

### 4. Automated Application Deployment
- **user_data Script**: Automatically installs Docker and runs Strapi in a container
- **Environment Management**: All environment-specific configurations managed via `tfvars` files
- **Production-ready Settings**: Environment variables configured for production deployment

### 5. Load Balancer Integration
- **Application Load Balancer**: Distributes incoming traffic to the Strapi application
- **Health Checks**: Monitors application health and automatically routes traffic
- **Public Accessibility**: Makes the private Strapi application accessible from the internet

## Infrastructure Components

### VPC Configuration
- CIDR Block: `10.0.0.0/16`
- Public Subnet 1: `10.0.1.0/24` (Availability Zone A)
- Private Subnet 1: `10.0.2.0/24` (Availability Zone A)
- Public Subnet 2: `10.0.3.0/24` (Availability Zone B)
- Private Subnet 2: `10.0.4.0/24` (Availability Zone B)

### Security Groups
- **ALB Security Group**: Allows HTTP traffic (port 80) from the internet
- **EC2 Security Group**: Allows Strapi traffic (port 1337) from ALB and SSH access (port 22) from authorized IP addresses

### EC2 Instance
- Amazon Linux 2 AMI
- Instance Type: Configurable via `tfvars`
- Deployed in private subnet with no direct internet access
- Automatically installs Docker and runs Strapi via user_data
- Accessible only through SSH key pair

### Strapi Application
- Runs in Docker container
- Exposed on configurable port (default 1337)
- Production-ready environment variables configured via user_data script
- Health check endpoint configured at `/admin`

### Load Balancer
- Public-facing Application Load Balancer
- Routes traffic to Strapi application
- Supports health checks for application monitoring

## Variables Configuration

All environment-specific configurations are managed through the `terraform.tfvars` file:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `aws_region` | AWS region for deployment | us-east-1 |
| `env` | Environment name (dev/staging/prod) | production |
| `vpc_cidr` | VPC CIDR block | 10.0.0.0/16 |
| `public_subnet_cidr` | Primary public subnet CIDR | 10.0.1.0/24 |
| `private_subnet_cidr` | Primary private subnet CIDR | 10.0.2.0/24 |
| `public_subnet_cidr_2` | Secondary public subnet CIDR | 10.0.3.0/24 |
| `private_subnet_cidr_2` | Secondary private subnet CIDR | 10.0.4.0/24 |
| `instance_type` | EC2 instance type | t3.medium |
| `key_name` | SSH key pair name | your-key-pair-name |
| `strapi_port` | Port on which Strapi runs | 1337 |

## Deployment Process

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform installed

### Steps
1. Clone this repository
2. Configure your AWS credentials
3. Update the `terraform.tfvars` file with your environment-specific values
4. Initialize Terraform: `terraform init`
5. Review the execution plan: `terraform plan`
6. Deploy the infrastructure: `terraform apply`
7. Access the Strapi application using the ALB DNS name from the outputs

### Accessing the Application
1. After deployment, retrieve the ALB DNS name from Terraform outputs
2. Navigate to `http://<alb-dns-name>` to access the Strapi application
3. To access the admin panel, navigate to `http://<alb-dns-name>/admin`

### Accessing the EC2 Instance
1. Use the SSH key pair to connect to the private EC2 instance
2. Connect using: `ssh -i <key-file> ec2-user@<ec2-private-ip>`
3. Note: You may need to connect via a bastion host or VPN depending on your security setup

## Security Best Practices Implemented

1. **Network Isolation**: EC2 instance runs in private subnet with no direct internet access
2. **Principle of Least Privilege**: Security groups restrict access to only necessary ports
3. **Automated Updates**: user_data script ensures Docker and Strapi are properly installed
4. **Secure Authentication**: SSH access via key pairs instead of passwords
5. **Traffic Filtering**: Load balancer acts as a security layer between internet and application
6. **Environment Management**: Sensitive configuration managed through tfvars files

## Customization Options

### Changing Instance Type
Modify the `instance_type` variable in `terraform.tfvars` to select a different EC2 instance type based on your performance requirements.

### Adjusting Network Configuration
Update the CIDR blocks in `terraform.tfvars` to accommodate your network requirements.

### Modifying Security Access
Adjust the SSH access IP restrictions in `security.tf` to allow access from your authorized IP address or range.

### Updating Strapi Version
Change the Docker image in `user_data.sh` to deploy a different version of Strapi.

## Cleanup

To destroy all infrastructure and avoid ongoing costs:
1. Run `terraform destroy` in the project directory
2. Confirm the destruction when prompted
3. Wait for all resources to be removed

## Troubleshooting

### Application Not Accessible
- Verify the ALB DNS name is correct
- Check that the security groups allow traffic from your authorized IP
- Confirm that the Strapi application is running inside the Docker container

### SSH Connection Issues
- Verify the SSH key pair is correctly configured
- Check that your authorized IP address is allowed in the security group
- Ensure the instance is in a subnet with appropriate routing

### Docker Installation Failures
- Review the user_data script for errors
- Check cloud-init logs on the EC2 instance
- Verify the instance has outbound internet access through the NAT gateway

## Benefits of This Architecture

1. **Security**: Private EC2 instances with controlled access through load balancer
2. **Scalability**: Load balancer ready for multiple instances
3. **Reliability**: Multi-AZ deployment for high availability
4. **Cost Efficiency**: Private instances with NAT for internet access
5. **Automation**: Fully automated deployment and configuration
6. **Maintainability**: Infrastructure as code for easy replication and updates

## Conclusion

This Terraform implementation provides a secure, scalable, and production-ready environment for hosting Strapi applications. The architecture follows AWS best practices for security and reliability while maintaining simplicity for deployment and management.


The solution demonstrates how to properly isolate application servers in private subnets while still allowing them to access the internet for updates and external APIs through a NAT Gateway. The Application Load Balancer provides a secure entry point for users to access the Strapi application.
