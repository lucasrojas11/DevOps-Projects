# Deploying web application on EKS
This cloud-native web application is built using a mix of technologies. It's designed to be accessible to users via the internet, allowing them to vote for their preferred programming language out of six choices: C#, Python, Javascript, Go, Java and NodeJS

## Technical Stack
- **Frontend**: The frontend of this application is buildt using React and Javascript. It provides a responsive and user-friendly interface for casting votes
- **Backend and API**: The backend of this application is powered by Go (Golang). It serves as the API handling users voting requests. MongoDB is used as the database backend, configured with a replica set for data redundancy and high availability

# Kubernetes Resources
to deploy and manage this application effectively, we laverage Kubernetes and a variety of its resources:
- **Namespaces**: Kubernetes namespaces are utilized to create isolated environments for different components of the application, ensuring separation and organization.
- **Secret**: Kubernetes secrets store sensitive information, such as API keys or credentials, required by the application securly
- **Deployment** Kubernetes deployments define how many instances of the application should run and provide instructions for updates and scaling
- **Service**: Kubernetes services ensure that users can access the application by directing incoming traffic to the appropriate instances.
- **StatefulSet**: For components requiring statefulness, such as the MongoDB replica set, Kubernetes StatefulSets are employed to maintain order and unique identities.
- **PersistentVolume and PersistentVolumeClaim**: These Kubernetes resources manage the storage required for the application, ensuring data persistence and scalability.
![Project 2](../Screenshots/Project%20-%202/Project%20-%202(1).png)
## Steps to Deploy
Navigate to Your Aws Console

Click the “Search” field and search For EKS or select directly Elastic Kubernetes Service on the Recently visited tab
![](../Screenshots/Project%20-%202/0_0qGdeArOJ8B0woga.webp)
Click “Add cluster”
![](../Screenshots/Project%20-%202/0_X-cSGJWA7GZewEEl.webp)
Click “Create”
![](../Screenshots/Project%20-%202/0_PZyMJr0pknYbmcbO.webp)
Click the "Name" field and enter a unique name for the cluster that is anything you want. For example, I used Cloud and version 1.27
![](../Screenshots/Project%20-%202/0_ivgu5DKmhezf_x-C.webp)
Click on Amazon EKS User Guide for New IAM role creation.
![](../Screenshots/Project%20-%202/0_ZIZ5NeyXTZzHQeR4.webp)
You will get the below webpage and

Click "console.aws.amazon.com/iam"
![](../Screenshots/Project%20-%202/0_rlWZI9g-RFvnRVO4.webp)
You will be redirected to the IAM dashboard

Click "Roles"
![](../Screenshots/Project%20-%202/0_LPCnuMJG-a8MMmjF.webp)
Click “Create role”
![](../Screenshots/Project%20-%202/0_p0hHDABYQjwKIU72.webp)
Click “Allow AWS services like EC2, Lambda, or others to perform actions in this account.”
![](../Screenshots/Project%20-%202/0_gGPewuq6it8unNyE.webp)
Click “Choose a service or use case”
![](../Screenshots/Project%20-%202/0_lqMnQ2pIVcACbmXI.webp)

Type “EKS”

Click this radio button with EKS-Cluster
![](../Screenshots/Project%20-%202/0_p0VLWgtgy--0v73R.webp)

Click “Next” and you will directly redirect to policy and click Next ( we have only one policy for it and it selects by default for EKS) that is `AmazonEKSClusterPolicy`
![](../Screenshots/Project%20-%202/0_QEmMZx41qBXQJlRa.webp)
Click the “Role name” field and provide the name (`myAmazonEKSClusterRole`)
![](../Screenshots/Project%20-%202/0_ky4ksCYT8aB-4G7Z.webp)
Click “Create role”
![](../Screenshots/Project%20-%202/0_Z-EtJzNQNzjVCl4X.webp)
Click “myAmazonEKSClusterRole” that is created at Cluster Service Role.
![](../Screenshots/Project%20-%202/0_8wMU_q-dq2PtRXtj.webp)
Click “Next”
![](../Screenshots/Project%20-%202/0_-eykme_klJM4jeTl.webp)
Click “Select security groups” and Use the existing security group or create a new security Group
![](../Screenshots/Project%20-%202/0_4Ti8vy9G4A7O1h_p.webp)
Click “Next”

Click “Next”

No changes Click “Next” (`Default no need to change anything`)

No changes Click “Next” (`Default no need to change anything`)

Click “Create”

In your cluster Click “Add-ons”
![](../Screenshots/Project%20-%202/0_SLFZmK7uVdFhLkpt.webp)
Click “Get more add-ons”
![](../Screenshots/Project%20-%202/0_As-BGCuNAEVXDT8e.webp)
Click this checkbox. with Amazon EBS CSI Driver
![](../Screenshots/Project%20-%202/0_nljtRNPLMcKKJse0.webp)
No changes Click “Next” (`Default no need to change anything`)

No changes Click “Next” (`Default no need to change anything`)

Click “Create”

Once your Cluster up to active status
![](../Screenshots/Project%20-%202/0_f1M3BQqZIT5V3wai.webp)
Click “Compute”
![](../Screenshots/Project%20-%202/0_7fTbSiJfBs2_E-G5.webp)
Click on “Add node group”
![](../Screenshots/Project%20-%202/0_xqWPhvRsIqy1oUei.webp)
Click the “Name” field.

Write any Name you want (`NodeGroup`)

Click “Select role” and click on the IAM console
![](../Screenshots/Project%20-%202/0_03M6H_8Q6fIK5mgS.webp)
Click “Create role”
![](../Screenshots/Project%20-%202/0_uyD1tyAspgXRhpgS.webp)
Click “Allow AWS services like EC2, Lambda, or others to perform actions in this account.”
![](../Screenshots/Project%20-%202/0_rSRiH0CG-DkuX6Dj.webp)
Click “Choose a service or use case”
![](../Screenshots/Project%20-%202/0_eTc3UMjrg7oADbIK.webp)
Click “EC2”
![](../Screenshots/Project%20-%202/0_7gmcXDJfQB2lpCVf.webp)

Click “Next”

Click the “Search” field.
![](../Screenshots/Project%20-%202/0_VMxDHqO9DvaAqNS5.webp)

Search these Policy Names and make it check

`AmazonEC2ContainerRegistryReadOnly`

`AmazonEKS_CNI_Policy`

`AmazonEBSCSIDriverPolicy`

`AmazonEKSWorkerNodePolicy`

Click “Next”

Click the “Role name” field.

Add Role name as myAmazonNodeGroupPolicy

Click “Create role”
![](../Screenshots/Project%20-%202/0_Ku3QQCs5UQ3cWAte.webp)
Add a role that was created before `“myAmazonNodeGroupPolicy"`
![](../Screenshots/Project%20-%202/0_aPy90oxnE3kJ9M37.webp)

Click “Next”

On the next page remove t3.medium and add t2.medium as instance type.

Select t2.medium
![](../Screenshots/Project%20-%202/0_rV6UF420Sss-jlHi.webp)
![](../Screenshots/Project%20-%202/0_LEUUTCy3fnii_bq4.webp)
Click “Next”
![](../Screenshots/Project%20-%202/0_8S3u8x5hitYtujOi.webp)
Click "Next"
![](../Screenshots/Project%20-%202/0_ZDuWvQwcTXmS8QZn.webp)
Click "Create"
![](../Screenshots/Project%20-%202/0_K54ACjBMpooxhXVu.webp)

Node Groups will take some time to create, Click “EC2” or Search for Ec2

Click “Launch instance”
![](../Screenshots/Project%20-%202/0_xhaliHThImnp56NT.webp)

Add Name and AMI as Amazon Linux
![](../Screenshots/Project%20-%202/0_4B3OuAfztgYx97Gq.webp)

Take instance type as t2.micro and select keypair with default security Group.

Click “Advanced details”
![](../Screenshots/Project%20-%202/0_1cv9DCNsRoahy6bi.webp)
Click on the IAM instance Profile and Create a New IAM profile.
![](../Screenshots/Project%20-%202/0_p8nqErFqsTV6scCQ.webp)
Click “Create role”
![](../Screenshots/Project%20-%202/0__JrNXKgjAgLX3C4b.webp)

Click “Choose a service or use case”
![](../Screenshots/Project%20-%202/0_oXEhz-XCR2R7wjU7.webp)
Click “EC2”

Click the “Search” field.

Type “EBS”

Click this checkbox with the policy name `AmazonEBSCSIDriverPolicy.`
![](../Screenshots/Project%20-%202/0_amC2A76C2gLd7y-2.webp)
Click “Next”

Click the “Role name” field and provide the name as `EKSaccess.`
![](../Screenshots/Project%20-%202/0_6_4bx7qQMwi1pYYe.webp)

Click “Create role”

Click on the newly created role “EKSaccess”
![](../Screenshots/Project%20-%202/0_xUWnQ_7frnHHsHqa.webp)
Click “Add permissions”
![](../Screenshots/Project%20-%202/0_6lxmUMI5nnnguwc9.webp)
Click “Create inline policy”
![](../Screenshots/Project%20-%202/0_Za7p0SFcL9Sb66Qb.webp)
Click “JSON”
![](../Screenshots/Project%20-%202/0_J74u4SmHI00dwAGd.webp)
REMOVE EVERYTHING FROM THE POLICY EDITOR

And add this
```
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Action": [
			"eks:DescribeCluster",
			"eks:ListClusters",
			"eks:DescribeNodegroup",
			"eks:ListNodegroups",
			"eks:ListUpdates",
			"eks:AccessKubernetesApi"
		],
		"Resource": "*"
	}]
}
```
Click “Next”

Click the “Policy name” field and add the name as `eksaccesspolicy`

click on create policy.

Add That Role to your instance and launch the instance
![](../Screenshots/Project%20-%202/0_X2_r1SfkmDr_TB2m.webp)

Once the instance comes up copy the SSH client to connect to Putty.
```
ssh -i "my-key-pair.pem" ec2-user@<public-ip>
```
Install git on the instance
```
sudo yum install git -y
```
![](../Screenshots/Project%20-%202/0_oMDKhbUW7Al59frQ.jpg)

Once Git is installed, install Kubectl on the instance
```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.11/2023-03-17/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo cp ./kubectl /usr/local/bin
export PATH=/usr/local/bin:$PATH
```
To check version:
```
kubectl version --client
```
Install AWS CLI on the instance:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
![](../Screenshots/Project%20-%202/0_pbP_o1pKH8PKOjxI.webp)

Check awscli version:
```
aws --version
```

Now check whether nodes are up or not
```
kubectl get nodes
```
![](../Screenshots/Project%20-%202/0_6mHW9xRcuvui1lFM.webp)

You will get a refused error because we haven’t set up the context yet. lets set context
```
aws eks update-kubeconfig --name EKS_CLUSTER_NAME --region CLUSTER_REGION
```
Example:
```
aws eks update-kubeconfig --name Cloud --region us-east-1
```

The `aws eks update-kubeconfig` command updates the Kubernetes configuration file with details for connecting to an Amazon EKS cluster.

Specifically:

- `--name EKS_CLUSTER_NAME` provides the name of the EKS cluster to configure access for. This should be replaced with your actual cluster name.
- `--Region us-east-1` specifies the AWS region where the EKS cluster is located. You should update this if your cluster is in a different region.
- This will update your local kubeconfig file (usually located at ~/.kube/config) with the endpoint and certificate authority data to allow kubectl to communicate with your EKS cluster.

Let’s check again whether nodes are up or not from instance.
```
kubectl get nodes
```

We will get an error that `You must be logged in to the server (unauthorized)`

The error message “You must be logged in to the server (Unauthorized)” in Kubernetes indicates that the user or service account trying to access the cluster does not have the necessary permissions. This error typically occurs when the authentication and authorization mechanisms in Kubernetes deny access.

Let’s Resolve the issue

Go to Aws console

Click on the AWS cloud shell icon on the top right

![](../Screenshots/Project%20-%202/0_pNkmDaTf7gFMFvjC.webp)

click on connect

First set context by providing the following command:
```
aws eks update-kubeconfig --name EKS_CLUSTER_NAME --region CLUSTER_REGION

Example:

aws eks update-kubeconfig --name Cloud --region us-east-1
```
Edit the config map for access
```
kubectl edit configmap aws-auth --namespace kube-system
```
![](../Screenshots/Project%20-%202/0_QsxNA63TwYDr2AXp.webp)
Go to your Iam roles and copy the arn of iam role of ec2 instance that is attached

Add your Role arn to the config map

`EKSaccess role is added to the Instance (While creating the instance)`
![](../Screenshots/Project%20-%202/0_PHnulcs5GTTqjBMq.webp)

```
- rolearn: arn:aws:iam::XXXXXXXXXXXX:role/testrole  #change arn of your instance role arn  
  username: testrole    #rolename 
  groups:
    - system:masters
#example
- rolearn: arn:aws:iam::672618677785:role/EKSaccess  #change arn
  username: EKSaccess    # iam role name 
  groups:
    - system:masters
```
![](../Screenshots/Project%20-%202/0_8u_ThKELymW8zhKz.webp)
save and exit
```
Esc --> shift+: 
wq!
```
You will get this output (aws-auth edited)
![](../Screenshots/Project%20-%202/0_v29LZ05751UNStCK.webp)

Check now whether nodes are up or not

(Not only in cloud shell you will get output like this in putty also)
```
kubectl get nodes
```
![](../Screenshots/Project%20-%202/0_3GEPiRYVXbf1D31y.webp)

Let’s clone our Project Repository
```
git clone <repo-url>
```

Go inside the K8s-voting app once it is cloned.
```
cd K8s-voting-app
cd manifests
ls
cat api-deployment.yaml
```
In the API deployment, we used a namespace as learnDevOps. By default we get 4 namespaces only, we have to create learnDevOps namespace.

Let’s create our learnDevOps namespace.
```
kubectl create ns learnDevOps
kubectl get ns
```

when you want to work within a specific namespace for your Kubernetes operations.

We have to set our namespace as current
```
kubectl config set-context --current --namespace learnDevOps
```

- `kubectl config set-context:` This is the main command for configuring your kubectl context.
- `--Current:` This flag indicates that you want to modify the current context.
- `--namespace learnDevOps:` This specifies the namespace you want to set as the current namespace for your kubectl context. In this case, it sets the namespace to "learnDevOps."

After running this command, any subsequent kubectl commands you execute will be scoped to the "learnDevOps" namespace, unless you specify a different namespace explicitly in your commands. This can be particularly useful when you have multiple namespaces in your Kubernetes cluster, and you want to ensure that your operations are isolated to a specific namespace.

## MONGO Database Setup
To create a Mongo stateful set with Persistent volumes, run the command in the manifests folder:
```
#to apply manifest file
kubectl apply -f mongo-statefulset.yaml
#to check pods 
kubectl get pods  (or) 
kubectl get pods -n learnDevOps -w
kubectl get all
```
Go to Aws console and click on nodes and storage You can see now new 1GB storage has been added to both nodes
![](../Screenshots/Project%20-%202/0_lZfKAXh8AERuEauj.webp)

Check whether persistent volumes are created or not
```
kubectl get pv -n learnDevOps  #-n means namespace we are mentioned special
kubectl get pvc -n learnDevOps
```
create Mongo Service
```
kubectl apply -f mongo-service.yaml
kubectl get svc
```

Now let’s go inside the mongo-0 pod and we have to initialise the Mongo database Replica set.

```
kubectl get pods
kubectl exec -it mongo-0 -- mongo
```
In the terminal run the following command:
```
rs.initiate();
sleep(2000);
rs.add("mongo-1.mongo:27017");
sleep(2000);
rs.add("mongo-2.mongo:27017");
sleep(2000);
cfg = rs.conf();
cfg.members[0].host = "mongo-0.mongo:27017";
rs.reconfig(cfg, {force: true});
sleep(5000);
```
![](../Screenshots/Project%20-%202/0_9mYz6gcCuqRbuoQP.webp)

Note: Wait until this command completes successfully, it typically takes 10–15 seconds to finish and completes with the message: bye

Load the Data in the database by running this command:
```
use langdb
```
copy single single line and paste inside mongo db
```
db.languages.insert({"name" : "csharp", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 5, "compiled" : false, "homepage" : "https://dotnet.microsoft.com/learn/csharp", "download" : "https://dotnet.microsoft.com/download/", "votes" : 0}});
db.languages.insert({"name" : "python", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 3, "script" : false, "homepage" : "https://www.python.org/", "download" : "https://www.python.org/downloads/", "votes" : 0}});
db.languages.insert({"name" : "javascript", "codedetail" : { "usecase" : "web, client-side", "rank" : 7, "script" : false, "homepage" : "https://en.wikipedia.org/wiki/JavaScript", "download" : "n/a", "votes" : 0}});
db.languages.insert({"name" : "go", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 12, "compiled" : true, "homepage" : "https://golang.org", "download" : "https://golang.org/dl/", "votes" : 0}});
db.languages.insert({"name" : "java", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 1, "compiled" : true, "homepage" : "https://www.java.com/en/", "download" : "https://www.java.com/en/download/", "votes" : 0}});
db.languages.insert({"name" : "nodejs", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 20, "script" : false, "homepage" : "https://nodejs.org/en/", "download" : "https://nodejs.org/en/download/", "votes" : 0}});
```
![](../Screenshots/Project%20-%202/0_XPYEjnfcOwAjuJqv.webp)

```
db.languages.find().pretty();
```
```
exit #exit from conatiner
```
To confirm run this in the terminal:
```
kubectl exec -it mongo-0 -- mongo --eval "rs.status()" | grep "PRIMARY\|SECONDARY"
```
Create Mongo secret:
```
kubectl apply -f mongo-secret.yaml
```
## API Setup
Create GO API deployment by running the following command:
```
kubectl apply -f api-deployment.yaml
kubectl get all
```
![](../Screenshots/Project%20-%202/0_KLXrPeIG2riJxZQI.webp)


Expose API deployment through service using the following command:
```
kubectl expose deploy api \
 --name=api \
 --type=LoadBalancer \
 --port=80 \
 --target-port=8080
```
```
kubectl get svc
```
One load Balancer will be created in your AWS account
![](../Screenshots/Project%20-%202/0_ChoT1JycrpCUzyy5.webp)

Next, set the environment variable:
```
{
API_ELB_PUBLIC_FQDN=$(kubectl get svc api -ojsonpath="{.status.loadBalancer.ingress[0].hostname}")
until nslookup $API_ELB_PUBLIC_FQDN >/dev/null 2>&1; do sleep 2 && echo waiting for DNS to propagate...; done
curl $API_ELB_PUBLIC_FQDN/ok
echo
}
```
![](../Screenshots/Project%20-%202/0_EUMAd9WXDb4SfbsWasfa.webp)
Test and confirm that the API route URL /languages, and /languages/{name} endpoints can be called successfully. In the terminal run any of the following commands:
```
<api loadbalancer ip/languages> #in browser
```

In the browser, you have to use your external IP of Api to see this output

![](../Screenshots/Project%20-%202/0_4LVgivMi_i0UaZVK.webp)

If everything works fine, go ahead with the Frontend setup.

## Frontend setup
```
kubectl apply -f frontend-deployment.yaml
kubectl get pods
```
```
kubectl get all
```

Expose API deployment through service using the following command:
```
kubectl expose deploy frontend \
 --name=frontend \
 --type=LoadBalancer \
 --port=80 \
 --target-port=8080
```
```
kubectl get svc
```
Next, set the environment variable:

```
{
FRONTEND_ELB_PUBLIC_FQDN=$(kubectl get svc frontend -ojsonpath="{.status.loadBalancer.ingress[0].hostname}")
until nslookup $FRONTEND_ELB_PUBLIC_FQDN >/dev/null 2>&1; do sleep 2 && echo waiting for DNS to propagate...; done
curl -I $FRONTEND_ELB_PUBLIC_FQDN
}
```

Generate the Frontend URL for browsing. In the terminal run the following command:
```
echo http://$FRONTEND_ELB_PUBLIC_FQDN
```

Test the full end-to-end cloud-native application
```
#frontend external ip in browser
<frontend service external-ip>
```
![](../Screenshots/Project%20-%202/0_1gKMxgqwcM7LkU1Y.jpg)
If you get output like this, Delete the service of frontend and deployment
```
kubectl delete -f frontend-service.yaml
kubectl delete -f frontend-deployment.yaml
```
Now copy your API External service ip
```
kubectl get svc
```
![](../Screenshots/Project%20-%202/0_hL13NOFQVuIoDHQ2.jpg)
Now open your frontend-deployment. yaml file
```
sudo vi frontend-deployment.yaml
```

Update the frontend-deployment.yaml file with your api-ip
![](../Screenshots/Project%20-%202/0_O_d-Vrq-yVdWXvhp.webp)

Now again deploy the frontend
```
kubectl apply -f frontend-deployment.yaml
```
and now expose the frontend-service
```
kubectl expose deploy frontend \
 --name=frontend \
 --type=LoadBalancer \
 --port=80 \
 --target-port=8080
```
Copy your external ip of the frontend service and paste it into the browser You will get an application like this
![](../Screenshots/Project%20-%202/0_744Qh5-wVJAKvirN.jpg)

Using your local workstation’s browser — browse to the URL created in the previous output.

After the voting application has loaded successfully, vote by clicking on several of the +1 buttons, This will generate AJAX traffic which will be sent back to the API via the API’s assigned ELB.

Query the MongoDB database directly to observe the updated vote data. In the terminal execute the following command:

```
kubectl exec -it mongo-0 -- mongo langdb --eval "db.languages.find().pretty()"
```
![](../Screenshots/Project%20-%202/0_GiK7HJzMP6M5_UjJ.jpg)