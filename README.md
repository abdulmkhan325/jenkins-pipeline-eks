# React App Deployment Using Red Hat OpenShift Service on AWS (ROSA)

This project deploys a React App on AWS through Red Hat OpenShift Service (ROSA Cluster) using a CI/CD workflow via Jenkins. The CI/CD process starts with an Ansible playbook that creates a ROSA cluster with a bash script. Tasks include building the React App, conducting tests, and deploying it on the OpenShift cluster. The React App is containerized with Docker and orchestrated using Kubernetes Operators written in Go.

### Skills Used: 
Shell Scripting, RedHat OpenShift Service on AWS, Jenkins CI/CD, Ansible, Docker, Kubernetes, Golang

# The pipeline strucutre:

### React Web App: 
it is a simple To-do web app.

### Ansible:
Ansible Playbook: Orchestrates different roles for specific tasks related to the application.

Scripts Folder: Contains organized scripts, such as the createcluster.sh bash script.

Roles:
  - Create Cluster: Ansible role responsible for creating a ROSA cluster, involving validating credentials and checking AWS Quota 
  - Delete Cluster: Ansible role for tearing down the cluster when no longer needed.

### Tekton-Pipeline:
Utilizing Tekton as the underlying framework for the CI/CD pipeline.

### Test Application:
Incorporating a testing phase in the CI/CD pipeline.

### Docker + OpenShift Container Platform (Kubernetes):

Containerization: Uses Docker to containerize the React App.

OpenShift Container Platform: Deploys the application on OpenShift, which is built on Kubernetes.

Operator: Manages containers on OCP/Kubernetes, handling deployment and application management.

### Deployment:
The Tekton pipeline includes a stage for deploying the operator, ensuring that the latest version is available in the environment.

