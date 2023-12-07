## Complete CI/CD Petclinic Project Devsecops

we will be deploying a Pet Clinic Java Based Application. This is an everyday use case scenario used by several organizations. We will be using Jenkins as a CICD tool and deploying our application on Tomcat Server.
We will be deploying our application in two ways, using Docker Container and other is using Tomcat Server. Finally, we will deploy Kubernetes Also.

And integrates manual approval also in this project.
![Project 3 architecture](../Screenshots/Project%20-%203/Screenshot%20(828).png)

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



















