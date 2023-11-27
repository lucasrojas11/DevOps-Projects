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