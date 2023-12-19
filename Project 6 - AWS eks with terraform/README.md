# Provisioning AWS EKS with Terraform

In the world of cloud computing and container orchestration, Amazon Web Services (AWS) Elastic Kubernetes Service (EKS) stands out as a popular choice for managing and scaling containerized applications. Combining the power of EKS with Infrastructure as Code (IaC) using Terraform makes infrastructure management even more efficient and predictable. In this step-by-step guide, we'll walk you through the process of provisioning an AWS EKS cluster using Terraform.

Before diving into the tutorial, make sure you have the following prerequisites in place:

AWS Account: You'll need an AWS account to create and manage resources.

AWS CLI: Install the AWS Command Line Interface and configure it with your AWS credentials.

Terraform: Download and install Terraform on your local machine.

## Step 1: download, install and setup Terraform on Windows
Download Terraform:

Visit the official Terraform website: https://www.terraform.io/downloads.html

Extract the ZIP Archive:

Once the download is complete, extract the contents of the ZIP archive to a directory on your computer. You can use a tool like 7-Zip or the built-in Windows extraction tool. Ensure that you extract it to a directory that's part of your system's PATH.
Create a Terraform Directory in C drive. Extracted to C drive and copy the path. **Add Terraform to Your System's PATH**
To make Terraform easily accessible from the command prompt, add the directory where Terraform is extracted to your system's PATH environment variable. Follow these steps:
- Search for "Environment Variables" in your Windows search bar and click "Edit the system environment variables."
- In the "System Properties" window, click the "Environment Variables" button.
- Under "User variables for Admin," find the "Path" variable and click "Edit."
- Click on New paste the copied path and click on OK, example: `C:\Terraform` 
- Under "System variables," find the "Path" variable and click "Edit."
- Click "New" and add the path to the directory where you extracted Terraform (e.g., C:\path\to\terraform).

Click "OK" to close the Environment Variables windows.

Click "OK" again to close the System Properties window.

Verify the Installation:

Open a new Command Prompt or PowerShell window.

Type `terraform --version` and press Enter. This command should display the Terraform version, confirming that Terraform is installed and in your PATH.

![](../Screenshots/Project%20-%205/Screenshot%20(952).png)

Your Terraform installation is now complete, and you can start using Terraform to manage your infrastructure as code.

## Step2: Download the AWS CLI Installer:
Visit the AWS CLI Downloads page: https://aws.amazon.com/cli/

Under "Install the AWS CLI," click on the "64-bit" link to download the AWS CLI installer for Windows.
- Run the Installer: Locate the downloaded installer executable (e.g., AWSCLIV2.exe) and double-click it to run the installer.
- Click on Next
- Agree to terms and click on Next
- Click Next
- Click on install
- Click Finish Aws cli is installed
**Verify the Installation:**
Open a Command Prompt or PowerShell window.
Type `aws --version` and press Enter. This command should display the AWS CLI version, confirming that the installation was successful.

![](../Screenshots/Project%20-%205/Screenshot%20(953).png)

## Step3: create an IAM user
Navigate to the AWS console

Click the "Search" field.

![](../Screenshots/Project%20-%205/Screenshot%20(954).png)


Search for IAM

![](../Screenshots/Project%20-%205/Screenshot%20(955).png)

Click "Users"

![](../Screenshots/Project%20-%205/Screenshot%20(956).png)

Click "Add users"

![](../Screenshots/Project%20-%205/Screenshot%20(957).png)

Click the "User name" field.

![](../Screenshots/Project%20-%205/Screenshot%20(958).png)

Type "Terraform" or as you wish about the name

Click Next

![](../Screenshots/Project%20-%205/Screenshot%20(959).png)

Click "Attach policies directly"

![](../Screenshots/Project%20-%205/Screenshot%20(960).png)

Click this checkbox with Administrator access

![](../Screenshots/Project%20-%205/Screenshot%20(961).png)

Click "Next"

![](../Screenshots/Project%20-%205/Screenshot%20(962).png)

Click "Create user"

![](../Screenshots/Project%20-%205/Screenshot%20(963).png)

Click newly created user in my case Admin

Click "Security credentials"

![](../Screenshots/Project%20-%205/Screenshot%20(964).png)

Click "Create access key"

![](../Screenshots/Project%20-%205/Screenshot%20(965).png)

Click this radio button with the CLI

![](../Screenshots/Project%20-%205/Screenshot%20(966).png)

Agree to terms

![](../Screenshots/Project%20-%205/Screenshot%20(967).png)

Click Next

![](../Screenshots/Project%20-%205/Screenshot%20(968).png)

Click "Create access key"

![](../Screenshots/Project%20-%205/Screenshot%20(969).png)

Download .csv file

![](../Screenshots/Project%20-%205/Screenshot%20(970).png)

Step4: Aws Configure
Go to CLI
``` 
aws configure
```
Provide your Aws Access key and Secret Access key

![](../Screenshots/Project%20-%205/Screenshot%20(971).png)

**provider.tf**
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"  #change your region
}
```

**main.tf**
```
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "eks_cluster_policy" {
  name       = "eks-cluster-policy"
  roles      = [aws_iam_role.eks_cluster.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Get default VPC id
data "aws_vpc" "default" {
  default = true
}

# Get public subnets in VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_eks_cluster" "eks" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = data.aws_subnets.public.ids
  }
}

resource "aws_iam_role" "example" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example.name
}

# Create managed node group
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "managed-nodes"
  node_role_arn   = aws_iam_role.example.arn

  subnet_ids = data.aws_subnets.public.ids
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = ["t2.micro"]

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.eks
  ]
}
```

Let's break down the Terraform configuration code into simpler terms:

1. **AWS IAM Role for EKS Cluster:**
    - This section creates an IAM (Identity and Access Management) role for your EKS cluster.

    - The role allows the EKS service to assume it, which means EKS can perform certain actions using this role.

    - The role is attached to a policy named "AmazonEKSClusterPolicy."

2. Default VPC and Public Subnets:

    - Here, we retrieve information about the default VPC and its public subnets.

    - The default VPC is where your EKS cluster will be deployed.

    - We identify the public subnets within the VPC.

3. AWS EKS Cluster:

    - This part creates the EKS cluster itself.

    - It uses the IAM role created earlier and deploys the cluster in the default VPC's public subnets.

4. IAM Role for EKS Node Group:

    - Another IAM role is created, which is meant for the worker nodes in your EKS cluster.

    - This role allows EC2 instances (worker nodes) to communicate with the EKS cluster.

5. Attachment of Policies:

    - Various policies, such as "AmazonEKSWorkerNodePolicy," "AmazonEKS_CNI_Policy," and "AmazonEC2ContainerRegistryReadOnly," are attached to the worker node role.

    - These policies grant permissions to the worker nodes for necessary actions.

6. Managed Node Group:

    - The EKS node group represents the worker nodes in your cluster.
    - It specifies the desired number of nodes, instance types, and other configurations.

    - The group is associated with the EKS cluster, the role of worker nodes, and the public subnets.

In vs code use the below commands to provision

```
terraform init
terraform validate
terraform plan
terraform apply
```
Once this is done you will see EKS cluster is created in the Aws console

In the cluster, click on Cloud shell

![](../Screenshots/Project%20-%206/Screenshot%20(976).png)

Now it will open a cloud shell to run commands and update Kubernetes configuration

![](../Screenshots/Project%20-%206/Screenshot%20(977).png)

Run this command
```
aws eks update-kubeconfig --name <cluster-name> --region <cluster-region>
```
Now add your iam credentials that were created. Not to get an error like this

![](../Screenshots/Project%20-%206/Screenshot%20(978).png)

Now provide
```
aws configure #add ur credentials
```
![](../Screenshots/Project%20-%206/Screenshot%20(979).png)

If you provide this command now you can see your nodes
```
kubectl get nodes
```

![](../Screenshots/Project%20-%206/Screenshot%20(980).png)

To Destroy
```
terraform destroy
```
In summary, the Terraform code provided here automates the process of creating an AWS EKS cluster, complete with the necessary IAM roles, policies, and configurations. This Infrastructure as Code (IaC) approach allows you to efficiently manage and scale your containerized applications in a secure and organized manner.

By utilizing Terraform to provision your EKS cluster, you're not only streamlining the setup process but also ensuring that your infrastructure is consistent, reproducible, and easy to modify as your needs evolve. The IAM roles and policies set up in this configuration define the permissions required for EKS and its worker nodes, enhancing the security of your cluster.

Remember that this is just a basic example, and EKS and Terraform provide numerous configuration options to tailor your cluster to specific requirements. Whether you're setting up a development environment or preparing for a production-ready deployment, understanding the principles outlined here will serve as a solid foundation for your EKS journey.

If you found this tutorial helpful, be sure to explore further, experiment with different configurations, and stay updated with the latest AWS and Terraform developments. Building containerized applications on AWS EKS with Terraform is a powerful approach, and with continuous learning, you can harness its full potential for your projects.

Happy orchestrating!