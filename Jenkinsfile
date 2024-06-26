import java.text.SimpleDateFormat
import java.util.Date 

def date = new Date()
def dateStamp = new SimpleDateFormat("yyyy.MM.dd").format(date)
def clusterName = "rosa-${dateStamp}"
def eksClusterName = "my-eks-cluster"
def aws_region = "ap-southeast-2"

def dockerImage = "react-app"
def dockerTag = "v${dateStamp}"
def dockerUserName = "abdulmkhan325"
def dockerHubRepo = "abdulmkhan325/github-projects"

echo "Cluster Name: ${clusterName}"

pipeline {  
    agent any
  
    environment {
        ROSA_TOKEN =  credentials('aws-token-rosa') 
        DOCKER_PASS = credentials('docker-password') 
        AWS_CREDENTIALS_ID = 'aws-majid-v2'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') 
        AWS_DEFAULT_REGION = "ap-southeast-2"
    }

    stages {
        // Check sudo permissions for jenkins
        stage('Check sudo privileage') {
            steps { 
                sh """
                    whoami
                    sudo ls
                """
            }
        }
        // Upgrade yum Package Manager
        stage('Yum Upgrade') {
            steps {
                script {
                    // Check if there are updates available
                    def updatesAvailable = sh(script: 'sudo yum check-update', returnStatus: true) == 100
                    if (updatesAvailable) { 
                        sh """
                            sudo yum upgrade -y
                            yum --version
                        """.stripIndent()
                    } else {
                        echo "No updates available."
                    }
                }
            }
        }
        // Install Dependencies and Check
        stage('Install Dependencies') {
            steps {
                script {
                    // Check if Installed 
                    def terraformInstalled = sh(script: 'which terraform', returnStatus: true) == 0
                    def kubectlInstalled = sh(script: 'which kubectl', returnStatus: true) == 0
                    def ansibleInstalled = sh(script: 'which ansible', returnStatus: true) == 0 
                    def dockerInstalled = sh(script: 'which docker', returnStatus: true) == 0

                    // Install if not found 
                    if (!terraformInstalled) {
                        sh """
                            sudo yum install -y yum-utils shadow-utils
                            sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
                            sudo yum -y install terraform
                        """
                    }
                    if (!kubectlInstalled) {
                        sh """
                            sudo curl -LO https://dl.k8s.io/release/\$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
                            sudo chmod +x kubectl
                            sudo mv kubectl /usr/local/bin/
                        """
                    }
                    if (!ansibleInstalled) {
                        sh "sudo yum install ansible -y"
                    }
                    if (!dockerInstalled) {
                        sh "sudo yum install docker -y"
                    }
                    // Display versions of installed dependencies
                    sh """
                        terraform --version
                        kubectl version --client
                        ansible --version
                        docker --version  
                    """.stripIndent()
                }
            }
        } 

        // Docker Stages  
        stage("Docker Login"){
            steps { 
                sh """
                    docker login -u ${dockerUserName} -p ${DOCKER_PASS}   
                """
            }
        } 
        stage("Docker Build"){
            steps {    
                sh """
                    cd react-app    
                    docker build -t ${dockerImage} .      
                """
            }
        }
        stage("Docker Tag"){
            steps { 
                sh """ 
                    docker tag ${dockerImage} ${dockerHubRepo}:${dockerTag}     
                """
            }
        }
        stage("Docker Push"){
            steps { 
                sh """
                    docker push ${dockerHubRepo}:${dockerTag}     
                """
            }
        }
        // stage("Docker Run"){
        //     steps { 
        //         sh """
        //             docker run --rm -p 3000:3000 -v ${WORKSPACE}/react-app:/react-app ${dockerHubRepo}:${dockerTag}  
        //         """
        //     }
        // }
 
        // Terraform Stages 
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('infra'){
                        sh 'terraform init'
                    }
                }
            }
        } 
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('infra'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('infra'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('infra'){
                        sh 'terraform plan'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        stage('Creating/Destroying an EKS Cluster'){
            steps{
                script{
                    dir('infra') {
                        sh 'terraform $action --auto-approve'
                    }
                }
            }
        }
        stage('Deploying Nginx Application') {
            when {
                expression {
                    params.action == 'apply'
                }
            }
            steps{
                script{
                    dir('infra/config') {
                        sh """ 
                            aws eks update-kubeconfig --name ${eksClusterName} --region ${aws_region}  
                            export KUBECONFIG=/var/lib/jenkins/.kube/config
                            kubectl get svc
                            kubectl get pods
                        """
                    }
                }
            }
        }


    }
}