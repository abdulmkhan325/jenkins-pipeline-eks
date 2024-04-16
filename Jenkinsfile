import java.text.SimpleDateFormat
import java.util.Date 

def date = new Date()
def dateStamp = new SimpleDateFormat("yyyy-MM-dd").format(date)
def clusterName = "rosa-${dateStamp}"
def dockerImage = "react-app:v1-${dateStamp}"

//docker creds
def dockerUserName = "abdulmkhan325"
def dockerRepo = "abdulmkhan325/github-projects"

echo "Cluster Name: ${clusterName}"

pipeline {  
    agent any
  
    environment {
        ROSA_TOKEN =  credentials('aws-token-rosa') 
        DOCKER_PASS = credentials('docker-password') 
        AWS_CREDENTIALS_ID = 'aws-majid-v2'
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




    }
}