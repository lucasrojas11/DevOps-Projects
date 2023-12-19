# Python Video-to-Audio Microservices on EKS

## Architecture
![](../Screenshots/Porject%20-%204/architecture.png)

### Introduction

This document provides a step-by-step guide for deploying a Python-based microservice application on AWS Elastic Kubernetes Service (EKS). The application comprises four major microservices: `auth-server`, `converter-module`, `database-server` (PostgreSQL and MongoDB), and `notification-server`.

### Prerequisites

Before you begin, ensure that the following prerequisites are met:

1. **Create an AWS Account:** If you do not have an AWS account, create one by following the steps [here](https://docs.aws.amazon.com/streams/latest/dev/setting-up.html).

2. **Install Helm:** Helm is a Kubernetes package manager. Install Helm by following the instructions provided [here](https://helm.sh/docs/intro/install/).

3. **Python:** Ensure that Python is installed on your system. You can download it from the [official Python website](https://www.python.org/downloads/).

4. **AWS CLI:** Install the AWS Command Line Interface (CLI) following the official [installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

5. **Install kubectl:** Install the latest stable version of `kubectl` on your system. You can find installation instructions [here](https://kubernetes.io/docs/tasks/tools/).

6. **Databases:** Set up PostgreSQL and MongoDB for your application.

## High Level Flow of Application Deployment

Follow these steps to deploy your microservice application:

1. **MongoDB and PostgreSQL Setup:** Create databases and enable automatic connections to them.

2. **RabbitMQ Deployment:** Deploy RabbitMQ for message queuing, which is required for the `converter-module`.

3. **Create Queues in RabbitMQ:** Before deploying the `converter-module`, create two queues in RabbitMQ: `mp3` and `video`.

4. **Deploy Microservices:**
   - **auth-server:** Navigate to the `auth-server` manifest folder and apply the configuration.
   - **gateway-server:** Deploy the `gateway-server`.
   - **converter-module:** Deploy the `converter-module`. Make sure to provide your email and password in `converter/manifest/secret.yaml`.
   - **notification-server:** Configure email for notifications and two-factor authentication (2FA).

5. **Application Validation:** Verify the status of all components by running:
   ```bash
   kubectl get all
   ```

6. **Destroying the Infrastructure** 

## Low Level Steps

### Launch an EC2 Instance
To launch an AWS EC2 instance with Ubuntu 22.04 using the AWS Management Console, sign in to your AWS account, access the EC2 dashboard, and click "Launch Instances." In "Step 1," select "Ubuntu 22.04" as the AMI, and in "Step 2," choose "t2.medium" as the instance type. Configure the instance details, storage, tags, and security group settings according to your requirements. Review the settings, create or select a key pair for secure access, and launch the instance. Once launched, you can connect to it via SSH using the associated key pair.

### Create an IAM ROLE
Navigate to AWS CONSOLE

Click the "Search" field.
![](../Screenshots/Porject%20-%204/Screenshot%20(886).png)

Type "IAM enter"

Click "Roles"

Click "Create role"
![](../Screenshots/Porject%20-%204/Screenshot%20(887).png)

Click "AWS service"

Click "Choose a service or use case"
![](../Screenshots/Porject%20-%204/Screenshot%20(888).png)

Click "EC2"

Click "Next"

![](../Screenshots/Porject%20-%204/Screenshot%20(889).png)

Click the "Search" field.

Add permissions policies

Administrator Access

Click Next

Click the "Role name" field, Add the name

Click "Create role" (JUST SAMPLE IMAGE BELOW ONE)
![](../Screenshots/Porject%20-%204/Screenshot%20(890).png)

Click "EC2"

Go to the instance and add this role to the Ec2 instance.

Select instance --> Actions --> Security --> Modify IAM role

Add a newly created Role and click on Update IAM role.
![](../Screenshots/Porject%20-%204/Screenshot%20(891).png)

Now connect to your Ec2 instance using Putty or Mobaxtrem.

Clone this repo

```
https://github.com/lucasrojas11/microservices-python-app.git
```

Change into the microservices directory

```
cd microservices-python-app
```

Provide the executable permissions to the script.sh file
```
sudo chmod +x script.sh
#run this script
./script.sh
```

```
#install docker
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker ubuntu  
newgrp docker
sudo chmod 777 /var/run/docker.sock

# Install Terraform
sudo apt install wget -y
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install kubectl
sudo apt update
sudo apt install curl -y
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# Install AWS CLI 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install unzip -y
unzip awscliv2.zip
sudo ./aws/install

#install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#install python
sudo apt update
sudo apt install python3 -y

#install postgresql
#!/bin/bash
# Update the package list and install PostgreSQL
sudo apt update
sudo apt install -y postgresql postgresql-contrib
# Start the PostgreSQL service and enable it on boot
sudo systemctl start postgresql
sudo systemctl enable postgresql

#mongoDB
sudo apt update
sudo apt install wget curl gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release -y
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-6.gpg
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install mongodb-org -y
sudo systemctl enable --now mongod
sudo systemctl status mongod
mongod --version
```
This script does the following:
1. Installs Terraform.
2. Installs kubectl.
3. Installs AWS CLI.
4. Installs Helm.
5. Installs Python.
6. Installs PostgreSQL.
7. Installs MongoDB.

It sets up your system with the necessary tools and services for your environment.

Check versions once the script completes running.

```
# Check Versions
terraform -version
kubectl version --client --short
aws --version
helm version --short
python3 --version
postgres --version
mongod --version
docker version
```

![](../Screenshots/Porject%20-%204/Screenshot%20(896).png)
![](../Screenshots/Porject%20-%204/Screenshot%20(897).png)

Now go inside Eks-terraform to provison Eks cluster with terraform files
```
cd eks-terraform
```
![](../Screenshots/Porject%20-%204/Screenshot%20(898).png)

Now you can see terraform files and make sure to change your region and S3 bucket name in the backend file.

Now initialize
```
terraform init
```
![](../Screenshots/Porject%20-%204/Screenshot%20(899).png)

Validate the code
```
terraform validate
```
![](../Screenshots/Porject%20-%204/Screenshot%20(900).png)

Let's see plan
```
terraform plan
```
![](../Screenshots/Porject%20-%204/Screenshot%20(901).png)

Let's apply to provision
```
terraform apply --auto-approve
```
![](../Screenshots/Porject%20-%204/Screenshot%20(902).png)

it will take 10 minutes to provision
![](../Screenshots/Porject%20-%204/Screenshot%20(903).png)

It will create a cluster and node group with one ec2 instance
![](../Screenshots/Porject%20-%204/Screenshot%20(904).png)

Node group ec2 instance
![](../Screenshots/Porject%20-%204/Screenshot%20(905).png)

Now come outside of the Eks-terraform directory.
```
cd ..
```
Now update the Kubernetes configuration
```
aws eks update-kubeconfig --name <cluster-name> --region <region>
```


Let's see the nodes
```
kubectl get nodes
```
![](../Screenshots/Porject%20-%204/Screenshot%20(907).png)

If you provide ls, you will see Helm_charts

```
ls -a
```
![](../Screenshots/Porject%20-%204/Screenshot%20(908).png)

Let's go inside the Helm_charts

```
cd Helm_charts
ls
```
Now go inside MongoDB and apply the k8s files

```
cd MongoDB
ls
helm install mongo .   #to apply all deployment and service files
```
![](../Screenshots/Porject%20-%204/Screenshot%20(909).png)

Now provide the command
```
kubectl get all
```
![](../Screenshots/Porject%20-%204/Screenshot%20(910).png)

Now see Persistent volume
```
kubectl get pv
```
![](../Screenshots/Porject%20-%204/Screenshot%20(911).png)

Now come back
```
cd ..
cd Postgres
sudo vi init.sql
```
Change your mail here
![](../Screenshots/Porject%20-%204/Screenshot%20(912).png)

Apply the Kubernetes files using Helm
```
helm install postgres .
```
![](../Screenshots/Porject%20-%204/Screenshot%20(913).png)

Let's see the pods and deployments
```
kubectl get all
```
![](../Screenshots/Porject%20-%204/Screenshot%20(914).png)

Let's add some ports for our node group ec2 instance

Go to the Node group ec2 instance and select the security group of the node group

Add these rules for it
![](../Screenshots/Porject%20-%204/Screenshot%20(915).png)

Now copy the public IP of the Node group ec2 instance

Go back to Putty and paste the following command with updated details

```
mongosh mongodb://<username>:<pwd>@<nodeip>:30005/mp3s?authSource=admin
#username use lucas
#pwd lucas1234    #if you want to update them go to mongo secrets.yml file and update
#nodeip #use your node ec2 instance ip
```

Now you are connected to MongoDB. come out of it.
```
exit
```
Connect to the Postgres database and copy all the queries from the "init.sql" file.
```
psql 'postgres://<username>:<pwd>@<nodeip>:30003/authdb'
#username lucas
#pwd cnd2023
#nodeip node group ec2 public ip
```

Now it's connected to psql

Now add the init.sql file
```
CREATE TABLE auth_user (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email VARCHAR (255) NOT NULL,
    password VARCHAR (255) NOT NULL
);

--Add Username and Password for Admin User
-- INSERT INTO auth_user (email, password) VALUES ('thomasfookins007helby@gmail.com', '123456');
INSERT INTO auth_user (email, password) VALUES ('<User your mail>', '123456');
```
Use your mail for values

![](../Screenshots/Porject%20-%204/Screenshot%20(918).png)

Now provide \d to see data tables
```
\d
```
Now provide the below command to see the authentication user
```
SELECT * from auth_user;
```
![](../Screenshots/Porject%20-%204/Screenshot%20(920).png)

You will get your email and password.

Now provide an exit to come out of psql
```
exit
```
Now change the directory into RabbitMq to deploy
```
#if you are at Postgres directory use 
cd ..
cd RabbitMQ
ls
helm install rabbit .
```
![](../Screenshots/Porject%20-%204/Screenshot%20(921).png)

Now see the deployments and pods
```
kubectl get all
```
![](../Screenshots/Porject%20-%204/Screenshot%20(922).png)

Now copy the public IP of the node group Ec2 instance
```
<Node-ec2-public-ip:30004>
```
You will get this page Just login
```
username is guest
password is guest
```
![](../Screenshots/Porject%20-%204/Screenshot%20(923).png)

After login, you will see this page
![](../Screenshots/Porject%20-%204/Screenshot%20(924).png)

Now click on Queues
![](../Screenshots/Porject%20-%204/Screenshot%20(925).png)

Click on Add a new Queue

Type as **classic**

Name **mp3** --> Add queue.
![](../Screenshots/Porject%20-%204/Screenshot%20(926).png)

Now click again Add a new queue for Video

Type as classic --> Name as video --> Add queue
![](../Screenshots/Porject%20-%204/Screenshot%20(927).png)

You will see queues like this.
![](../Screenshots/Porject%20-%204/Screenshot%20(928).png)

Now go back to Putty

Come out of helm charts

Microservices
```
cd ../..
#if you are at microservices-python-app
cd src
ls      #these are the microservices
```
![](../Screenshots/Porject%20-%204/Screenshot%20(929).png)

Now Go inside each microservice, and you will find a Dockerfile
you can create your docker images for each microservice and use it in the deployment file also.

First Go inside auth-service
```
cd auth-service
ls
cd manifest #directory
kubectl apply -f .
```
![](../Screenshots/Porject%20-%204/Screenshot%20(930).png)

Now let's see whether it created pods or not
```
kubectl get all
```
![](../Screenshots/Porject%20-%204/Screenshot%20(931).png)

Now come back to another Microservice and do the same process
```
cd ../..
cd gateway-service
cd manifest
kubectl apply -f .
```
![](../Screenshots/Porject%20-%204/Screenshot%20(932).png)

Check
```
kubectl get all
```
![](../Screenshots/Porject%20-%204/Screenshot%20(933).png)

Now come back to another microservice and do the same process
```
cd ../..
cd converter-service
cd manifest
kubectl apply -f .
```
![](../Screenshots/Porject%20-%204/Screenshot%20(934).png)

Check for deployments and service
```
kubectl get all
```
![](../Screenshots/Porject%20-%204/Screenshot%20(935).png)

### GMAIL PASSWORD
Now let's create a Password for Gmail to get Notifications

Open your Gmail account in the browser and click on your profile top right.

Click on Manage your Google account

![](../Screenshots/Porject%20-%204/Screenshot%20(936).png)

Now click on Security
![](../Screenshots/Porject%20-%204/Screenshot%20(937).png)

Two-step verification should be enabled
If not, enable it
![](../Screenshots/Porject%20-%204/Screenshot%20(938).png)

Now click on the search bar and **search for the APP**

Click on App passwords
![](../Screenshots/Porject%20-%204/Screenshot%20(939).png)

It will ask for your Gmail password, provide and login

Now for the app name, you can use any name --> create
![](../Screenshots/Porject%20-%204/aad9d3d1-2589-45f0-a344-99a31e447f7c.avif)

You will get a Password, copy it and save it for later use.

One time watchable
![](../Screenshots/Porject%20-%204/Screenshot%20(940).png)

Come back to Putty and update the secret.yaml file for notification service microservice
```
cd ../..
cd notification-service
cd manifest
sudo vi secret.yaml
#change your mail and password that Generated.
```
![](../Screenshots/Porject%20-%204/Screenshot%20(941).png)

Now apply the manifest files
```
kubectl apply -f .
```
![](../Screenshots/Porject%20-%204/Screenshot%20(942).png)

Check whether it created deployments or not.
```
kubectl get all
```
![](../Screenshots/Porject%20-%204/Screenshot%20(943).png)

Now come to the assets directory
```
cd /home/ubuntu/microservice-python-app
cd assets
ls
curl -X POST http://nodeIP:30002/login -u <email>:<password>
```
![](../Screenshots/Porject%20-%204/Screenshot%20(944).png)

Copy the token and paste it inside a base 64 decoder you will get this
![](../Screenshots/Porject%20-%204/Screenshot%20(945).png)

change JWT Token and node ec2 IP.
```
 curl -X POST -F 'file=@./video.mp4' -H 'Authorization: Bearer <JWT Token>' http://nodeIP:30002/upload
```
![](../Screenshots/Porject%20-%204/Screenshot%20(946).png)

It will send an ID to the mail

Let's check the mail
![](../Screenshots/Porject%20-%204/Screenshot%20(947).png)

Copy that ID and paste it inside the below command with the JWT token and fid
```
curl --output video.mp3 -X GET -H 'Authorization: Bearer ' "http://nodeIP:30002/download?fid="
#change Bearer with JWT token
#nodeIp
#fid token at end
```
![](../Screenshots/Porject%20-%204/Screenshot%20(948).png)

It will download an MP3 file
```
ls
```
![](../Screenshots/Porject%20-%204/Screenshot%20(949).png)

You can see it's created mp3 file and you can play it.
```
aws s3 cp your-file s3://your-bucket/your-prefix/
```
You can copy it s3 bucket and download and you can listen to it.

### Destroy
Now go inside Eks-terraform directory

To delete eks cluster
```
terraform destroy --auto-approve
```
It will take 10 minutes to delete the cluster

![](../Screenshots/Porject%20-%204/Screenshot%20(950).png)

Once that is done
Remove your Ec2 instance and Iam role.





