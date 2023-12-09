## Complete CI/CD Petclinic Project Devsecops

we will be deploying a Pet Clinic Java Based Application. This is an everyday use case scenario used by several organizations. We will be using Jenkins as a CICD tool and deploying our application on Tomcat Server.
We will be deploying our application in two ways, using Docker Container and other is using Tomcat Server. Finally, we will deploy Kubernetes Also.

And integrates manual approval also in this project.
![Project 3 architecture](../Screenshots/Project%20-%203/Screenshot%20(828).png)

aplication code: https://github.com/Aj7Ay/Petclinic-Real.git

**Tools:**
- **AWS EC2:** Amazon Elastic Compute Cloud provides on-demand, scalable computing capacity in the Amazon Web Services (AWS) Cloud. Using Amazon EC2 reduces hardware costs so you can develop and deploy applications faster. You can use Amazon EC2 to launch as many or as few virtual servers as you need
- **Jenkins:** is an open source automation server used to build, test, and deploy software applications, is a widely adopted used by development teams for CI/CD to accelerate software delivery by reliably building, testing and deploying applications with speed, scale and efficiency
- **Docker:** is an open platform that enables developers to package applications along with their dependencies into standardized, isolated containers that can run consistently across different environments and infrastructures. It facilitates portability, consistency, and efficiency in developing, shipping, and running applications.
- **Trivy:**  is an open source vulnerability scanner for container images and filesystems. It detects vulnerabilities and misconfigurations in Kubernetes, Docker, and OS packages by analyzing metadata in a lightweight and fast manner without needing to spin up containers.
- **Sonarqube:**  is an open source platform for continuous inspection of code quality to perform automatic reviews and highlight bugs, security vulnerabilities, and code smells in over 20 programming languages. It provides detailed reports and dashboards to foster cleaner, safer code.
- **Maven:** is a build automation tool used primarily for Java projects to manage and describe projects including dependencies, build, and documentation. It provides a standardized way to build and distribute packages leveraging a central repository of dependencies and plugins that brings consistency and efficiency to the build process. 
- **Jenkins Pipeline:**  is a suite of plugins and tools that enable Jenkins users to create pipelines as code by writing declarative or scripted pipelines coded in a DSL syntax and integrated with Jenkinsfiles. This allows creating CI/CD workflows programmatically with version control instead of static job configs.
- **Tomcat:** is an open-source application server developed by the Apache Software Foundation. Providing a pure Java HTTP web server environment for Java code to run in. It is used to deploy Java servlets and JavaServer Pages (JSP) for building and deploying web applications.
- **kubernetes:** is an open source container orchestration system for automating deployment, scaling, and management of containerized applications. It facilitates container clustering and lifecycle management for fault tolerance and high availability by coordinating compute, network, and storage infrastructure across data centers and clouds.

Steps:-

- Step 1 — Create an Ubuntu T2 Large Instance

- Step 2 — Install Jenkins, Docker and Trivy. Create a Sonarqube Container using Docker.

- Step 3 — Install Plugins like JDK, Sonarqube Scanner, Maven, OWASP Dependency Check,

- Step 4 — Create a Pipeline Project in Jenkins using a Declarative Pipeline

- Step 5 — Install OWASP Dependency Check Plugins

- Step 6 — Docker Image Build and Push

- Step 7 — Deploy the image using Docker

- Step 8 — Install Tomcat on Port 8083 and finally deploy on Apache Tomcat

- Step 9 — Deploy on Kubernetes

- Step 10 — Access the Real World Application

- Step 11 — Terminate the AWS EC2 Instance

Now, let's get started and dig deeper into each of these steps:-

**Step 1** — Launch an AWS T2 Large Instance. Use the image as Ubuntu. You can create a new key pair or use an existing one. Enable HTTP and HTTPS settings in the Security Group.

![](../Screenshots/Project%20-%203/Screenshot%20(829).png)

**Step 2** — Install Jenkins, Docker and Trivy

- 2A — To Install Jenkins

Connect to your console, and enter these commands to Install Jenkins.
```
sudo vi jenkins.sh # or use userdata 
sudo apt-get update

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install openjdk-17-jre -y

sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
#save and exit
sudo chmod 777 jenkins.sh
./jenkins.sh

```
Once Jenkins is installed, you will need to go to your AWS EC2 Security Group and open Inbound Port 8080, since Jenkins works on Port 8080.

![](../Screenshots/Project%20-%203/Screenshot%20(830).png)

Now, grab your Public IP Address
```
<EC2 Public IP Address:8080>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Unlock Jenkins using an administrative password and install the required plugins

![](../Screenshots/Project%20-%203/Screenshot%20(831).png)

Jenkins will now get installed and install all the libraries
Jenkins getting started screen

![](../Screenshots/Project%20-%203/Screenshot%20(832).png)
- 2B — Install Docker
```
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock 
sudo docker ps
```
After the docker installation, we create a sonarqube container (Remember added 9000 port in the security group)

![](../Screenshots/Project%20-%203/Screenshot%20(833).png)

```
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```

![](../Screenshots/Project%20-%203/Screenshot%20(834).png)


![](../Screenshots/Project%20-%203/Screenshot%20(836).png)

- 2C — Install Trivy
```
vi trivy.sh

#---Enter these---
sudo apt-get install wget apt-transport-https gnupg lsb-release -y

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

sudo apt-get update

sudo apt-get install trivy -y
#---SAVE AND EXIT---

sudo chmod 777 trivy.sh
./trivy.sh
```
Next, we will log in to Jenkins and start to configure our Pipeline in Jenkins

**Step 3** — Install Plugins like JDK, Sonarqube Scanner, Maven, OWASP Dependency Check,

- 3A — Install Plugin

Goto Manage Jenkins →Plugins → Available Plugins →

Install below plugins

1 → Eclipse Temurin Installer (Install without restart)

2 → SonarQube Scanner (Install without restart)

- 3B — Configure Java and Maven in Global Tool Configuration

Goto Manage Jenkins → Tools → Install JDK and Maven3 → Click on Apply and Save

- 3C — Create a Job

Label it as Real-World CI-CD, click on Pipeline and OK.

![](../Screenshots/Project%20-%203/Screenshot%20(837).png)

Enter this in Pipeline Script:
```
pipeline {
    agent any 
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
     stages{
        stage("Git Checkout"){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Aj7Ay/Petclinic.git'
            }
        }
        stage("Compile"){
            steps{
                sh "mvn clean compile"
            }
        }
         stage("Test Cases"){
            steps{
                sh "mvn test"
            }
        }
     }
}
```

The stage view would look like this:
![](../Screenshots/Project%20-%203/Screenshot%20(838).png)

**Step 4 — Configure Sonar Server in Manage Jenkins**

Grab the Public IP Address of your EC2 Instance, Sonarqube works on Port 9000, sp <Public IP>:9000. Goto your Sonarqube Server. Click on Administration → Security → Users → Click on Tokens and Update Token → Give it a name → and click on Generate Token
![](../Screenshots/Project%20-%203/Screenshot%20(839).png)

Click on Update Token

![](../Screenshots/Project%20-%203/Screenshot%20(840).png)

Copy this Token

Goto Dashboard → Manage Jenkins → Credentials → Add Secret Text. It should look like this
![](../Screenshots/Project%20-%203/Screenshot%20(841).png)

Now, go to Dashboard → Manage Jenkins → Configure System

![](../Screenshots/Project%20-%203/Screenshot%20(842).png)

Click on Apply and Save

The Configure System option is used in Jenkins to configure different server

Global Tool Configuration is used to configure different tools that we install using Plugins

We will install a sonar scanner in the tools.

![](../Screenshots/Project%20-%203/Screenshot%20(843).png)

Add Quality Gate in Sonarqube

click on Administration --> Configuration --> webhooks

![](../Screenshots/Project%20-%203/Screenshot%20(853).png)

Click on Create

![](../Screenshots/Project%20-%203/Screenshot%20(854).png)

Enter a URL like the below image

![](../Screenshots/Project%20-%203/Screenshot%20(855).png)

Let go to our pipeline and add the Sonar-qube Stage in our Pipeline Script
```
stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Petclinic \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Petclinic '''
                }
            }
        }
steps {
     steps {
         waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
     }
}

#---alternative Sonarqube Analysis---
stage ('sonarqube Analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'Sonar-token') {
                      sh 'mvn sonar:sonar'
                    }
                }
            }
        }

```

Click on Build now, you will see the stage view like this
![](../Screenshots/Project%20-%203/Screenshot%20(856).png)

To see the report, you can go to Sonarqube Server and go to Projects
![](../Screenshots/Project%20-%203/Screenshot%20(857).png)


You can see the report has been generated and the status shows as passed. You can see that there are 15K lines. To see a detailed report, you can go to issues.

**Step 5 — Install OWASP Dependency Check Plugins**

GotoDashboard → Manage Jenkins → Plugins → OWASP Dependency-Check. Click on it and install it without restarting.
![](../Screenshots/Project%20-%203/Screenshot%20(858).png)


First, we configured the Plugin and next, we had to configure the Tool

Goto Dashboard → Manage Jenkins → Tools →
![](../Screenshots/Project%20-%203/Screenshot%20(859).png)


Click on Apply and Save here.

Now go configure → Pipeline and add this stage to your pipeline

```
stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format XML ', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }

```

The final pipeline would look like this:
```
pipeline {
    agent any     
    tools{
        jdk 'jdk17'
        maven 'maven3'
    } 
     environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages{
        stage("Git Checkout"){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Aj7Ay/Petclinic.git'
            }
        }
        stage("Compile"){
            steps{
                sh "mvn clean compile"
            }
        }  
         stage("Test Cases"){
            steps{
                sh "mvn test"
            }
        } 
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Petclinic \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Petclinic '''
                }
            }
        }
        stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }
          stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format XML ' , odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        } 
    }
}

```

The stage view would look like this
![](../Screenshots/Project%20-%203/Screenshot%20(860).png)

You will see that in status, a graph will also be generated
![](../Screenshots/Project%20-%203/Screenshot%20(861).png)


**Steps 6 — Docker Image Build and Push**
We need to install the Docker tool in our system, Goto Dashboard → Manage Plugins → Available plugins → Search for Docker and install these plugins

- **Docker**

- **Docker Commons**

- **Docker Pipeline**

- **Docker API**

- **docker-build-step**

and click on install without restart

Now, goto Dashboard → Manage Jenkins → Tools →
![](../Screenshots/Project%20-%203/Screenshot%20(862).png)

Add DockerHub Username and Password under Global Credentials

![](../Screenshots/Project%20-%203/Screenshot%20(863).png)

Add this stage to pipeline Script
```
stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: ‘docker', toolName: 'docker') {  
                       sh "docker build -t petclinic1 ."
                       sh "docker tag petclinic1 Aj7Ay/pet-clinic123:latest "
                       sh "docker push Aj7Ay/pet-clinic123:latest "
                    }
                }
            }
        }
```
You will see the output bellow:
![](../Screenshots/Project%20-%203/Screenshot%20(864).png)

Now, when you do 
You will see this output

![](../Screenshots/Project%20-%203/Screenshot%20(865).png)

When you log in to Dockerhub, you will see a new image is created

**Step 7 — Deploy the image using Docker

Add this stage to your pipeline syntax

```
stage("Deploy Using Docker"){
            steps{
                sh " docker run -d --name pet1 -p 8082:8082 Aj7Ay/pet-clinic123:latest "
            }
        }

```
You will see the Stage view like this:
![](../Screenshots/Project%20-%203/Screenshot%20(867).png)

**Step 8 — Install Tomcat on Port 8083 and finally deploy on Apache Tomcat**

Before we add Pipeline Script, we need to install and configure Tomcat on our server.

Here are the steps to install Tomcat 9

Change to opt directory

```
cd /opt
```
Download the Tomcat file using the wget command
```
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz (Another link )
```
Unzip tar file
```
sudo tar -xvf apache-tomcat-9.0.65.tar.gz
Move to the conf directory and change the port in the Tomcat server to another port from the default port
```
```
cd /opt/apache-tomcat-9.0.65/conf
vi server.xml
```

Update Tomcat users' XML file for manager app login
```
cd /opt/apache-tomcat-9.0.65/conf
sudo vi tomcat-users.xml
```

---add-below-line at the end (2nd-last line)----
```
<user username="admin" password="admin1234" roles="admin-gui, manager-gui"/>
```

Create a symbolic link for the direct start and stop of Tomcat
```
sudo ln -s /opt/apache-tomcat-9.0.65/bin/startup.sh /usr/bin/startTomcat
sudo ln -s /opt/apache-tomcat-9.0.65/bin/shutdown.sh /usr/bin/stopTomcat
```
Go to this path and comment below lines in manager and host-manager
```
sudo vi /opt/apache-tomcat-9.0.65/webapps/manager/META-INF/context.xml
#comment these lines
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
```
```
sudo vi /opt/apache-tomcat-9.0.65/webapps/host-manager/META-INF/context.xml
#comment these lines
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
```
```
sudo stopTomcat
sudo startTomcat
```
Certainly! To allow both `ubuntu` and `Jenkins` users to copy the `petclinic.war` file to the `/opt/apache-tomcat-9.0.65/webapps/` directory without entering passwords, you can add the appropriate entries to the `/etc/sudoers` file. Here's how you can do it:

Open a terminal.

Use the `sudo` command to edit the sudoers file using a text editor like `visudo`:
```
sudo visudo
```
Scroll down to an appropriate section (e.g., just below the line with %sudo ALL=(ALL:ALL) ALL) and add the following lines:

```
#after workspace change your job name 
ubuntu ALL=(ALL) NOPASSWD: /bin/cp /var/lib/jenkins/workspace/petclinic/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/ 
jenkins ALL=(ALL) NOPASSWD: /bin/cp /var/lib/jenkins/workspace/petclinic/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/
```
Save the file and exit the text editor.

By adding these lines, you're allowing both the `Ubuntu` user and the `Jenkins` user to run the specified `cp` command without being prompted for a password.

After making these changes, both users should be able to run the Jenkins job that copies the `petclinic.war` file to the specified directory without encountering permission issues. Always ensure that you're cautious when editing the sudoers file and that you verify the paths and syntax before saving any changes.

Since 8080 is being used by Jenkins, we have used Port 8083 to host the Tomcat Server
```
<EC2 Public IP Address:8083>
```
Add this stage to your pipeline script
```
stage("Deploy To Tomcat"){
            steps{
                sh "cp  /var/lib/jenkins/workspace/Real-World-CI-CD/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/ "
            }
        }
```

Kindly note that this application can be deployed via Docker and also via Tomcat Server. Here I have used Tomcat to deploy the application

The final script looks like this(Rough):
```
#rough pipeline just for reference complete pipeline at end
pipeline {
    agent any 

    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
     environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages{  
        stage("Git Checkout"){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Aj7Ay/Petclinic.git'
            }
        }

        stage("Compile"){
            steps{
                sh "mvn clean compile"
            }
        }
         stage("Test Cases"){
            steps{
                sh "mvn test"
            }
        }
        stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }

          stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format XML ' , odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage("Docker Build & Push"){
            steps{
                script{
                        withDockerRegistry(credentialsId: 'docker’, toolName: 'docker') {  
                             sh "docker build -t petclinic1 ."
                             sh "docker tag petclinic1 Aj7Ay/pet-clinic123:latest "
                             sh "docker push Aj7Ay/pet-clinic123:latest "
                    }
                }
            }
        }
        stage("Deploy Using Docker"){
            steps{
                sh " docker run -d --name pet12 -p 8082:8082 Aj7Ay/pet-clinic123:latest "
            }
        }
        stage("Deploy To Tomcat"){
            steps{
                sh "cp  target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/ "
            }
        }
    }
}

```

And you can access your application on Port 8083. This is a Real World Application that has all Functional Tabs.

![](../Screenshots/Project%20-%203/Screenshot%20(877).png)

**Step 9 — Access the Real World Application**
```
<public-ip:8083/petclinic>
```
![](../Screenshots/Project%20-%203/Screenshot%20(878).png)

![](../Screenshots/Project%20-%203/Screenshot%20(879).png)

![](../Screenshots/Project%20-%203/Screenshot%20(880).png)


**STEP:10 Take Two Ubuntu 20.04 instances one for the k8s master and the other one for the worker Also install on the Jenkins machine (only kubectl)**

Kubectl on Jenkins to be installed
```
sudo apt update
sudo apt install curl
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version –client
```

Part 1 -------------Master ------------
```
sudo su
hostname master
bash
clear
```

-------------Node --------------
```
sudo su
hostname worker
bash
clear
```

Part 2 -------------------Both Master & Node -------------
```
sudo apt-get update 
sudo apt-get install -y docker.io
sudo usermod –aG docker Ubuntu
newgrp docker
sudo chmod 777 /var/run/docker.sock

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo tee /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo snap install kube-apiserver
```

Part 3 --------------------Master ---------------
```
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

-------------Node ----------
```
#paste the kube adm join command which is in this format: 
sudo kubeadm join <master-node-ip>:<master-node-port> --token <token> --discovery-token-ca-cert-hash <hash>
```
on Master

```
kubectl get nodes
```
CONGRATULATIONS ON YOUR NEW KUBERNETES CLUSTER ON UBUNTU ON EC2

Copy the config file to Jenkins master or the local file manager and save it

Install Kubernetes plugins

Install the Kubernetes Plugin, once it's installed successfully. Go to manage Jenkins --> manage credentials --> Click on Jenkins global --> add credentials.


## Configuring mail server in Jenkins ( Gmail )
Install `Email Extension Plugin in Jenkins`

Once the plugin is installed in Jenkins, click on manage Jenkins --> configure system there under the E-mail Notification section configure the details as shown in the below image

![](../Screenshots/Project%20-%203/Screenshot%20(871).png)

This is to just verify the mail configuration

Now under the Extended E-mail Notification section configure the details as shown in the below images

![](../Screenshots/Project%20-%203/Screenshot%20(872).png)

![](../Screenshots/Project%20-%203/Screenshot%20(873).png)

![](../Screenshots/Project%20-%203/Screenshot%20(874).png)

By using the bellow code i can send customized mail
```
post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'postbox.aj99@gmail.com',   #change mail here
            attachmentsPattern: 'trivy.txt'
        }
    }
```

And kubernetes deployment to pipeline
```
stage('Deploy to kubernets'){
            steps{
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                       sh 'kubectl apply -f deployment.yaml'
                  }
                }
            }
```

```
#after deployment in kubernetes cluster enter this command
kubectl get all # to check everything is deployed or not
```


**Step 11 — Terminate the AWS EC2 Instance**

Lastly, do not forget to terminate the AWS EC2 Instance.

Complete Pipeline

```
pipeline{
    agent any
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout From Git'){
            steps{
                git branch: 'main', url: 'https://github.com/Aj7Ay/Petclinic-Real.git'
            }
        }
        stage('mvn compile'){
            steps{
                sh 'mvn clean compile'
            }
        }
        stage('mvn test'){
            steps{
                sh 'mvn test'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Petclinic \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Petclinic '''
                }
            }
        }
        stage("quality gate"){
           steps {
                 script {
                     waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
                    }
                } 
        } 
        stage('mvn build'){
            steps{
                sh 'mvn clean install'
            }
        }  
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format HTML ', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.html'
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                       sh "docker build -t petclinic1 ."
                       sh "docker tag petclinic1 sevenajay/petclinic1:latest "
                       sh "docker push sevenajay/petclinic1:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image sevenajay/petclinic1:latest > trivy.txt" 
            }
        }
        stage('Clean up containers') {   //if container runs it will stop and remove this block
          steps {
           script {
             try {
                sh 'docker stop pet1'
                sh 'docker rm pet1'
                } catch (Exception e) {
                  echo "Container pet1 not found, moving to next stage"  
                }
            }
          }
        }
        stage ('Manual Approval'){
          steps {
           script {
             timeout(time: 10, unit: 'MINUTES') {
              def approvalMailContent = """
              Project: ${env.JOB_NAME}
              Build Number: ${env.BUILD_NUMBER}
              Go to build URL and approve the deployment request.
              URL de build: ${env.BUILD_URL}
              """
             mail(
             to: 'postbox.aj99@gmail.com',
             subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", 
             body: approvalMailContent,
             mimeType: 'text/plain'
             )
            input(
            id: "DeployGate",
            message: "Deploy ${params.project_name}?",
            submitter: "approver",
            parameters: [choice(name: 'action', choices: ['Deploy'], description: 'Approve deployment')]
            )  
          }
         }
       }
    }
        stage('Deploy to conatiner'){
            steps{
                sh 'docker run -d --name pet1 -p 8082:8080 sevenajay/petclinic1:latest'
            }
        }
        stage("Deploy To Tomcat"){
            steps{
                sh "sudo cp  /var/lib/jenkins/workspace/petclinic/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/ "
            }
        }
        stage('Deploy to kubernets'){
            steps{
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                       sh 'kubectl apply -f deployment.yaml'
                  }
                }
            }
        }
    }
    post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'postbox.aj99@gmail.com',   #//change mail
            attachmentsPattern: 'trivy.txt'
        }
    }
}

#// try this approval stage also 

stage('Manual Approval') {
  timeout(time: 10, unit: 'MINUTES') {
    mail to: 'postbox.aj99@gmail.com',
         subject: "${currentBuild.result} CI: ${env.JOB_NAME}",
         body: "Project: ${env.JOB_NAME}\nBuild Number: ${env.BUILD_NUMBER}\nGo to ${env.BUILD_URL} and approve deployment"
    input message: "Deploy ${params.project_name}?", 
           id: "DeployGate", 
           submitter: "approver", 
           parameters: [choice(name: 'action', choices: ['Deploy'], description: 'Approve deployment')]
  }
}


```