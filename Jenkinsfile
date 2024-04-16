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
                sh """  
                    sudo yum upgrade -y
                    yum --version
                """.stripIndent()  
            }
        }  
    }
}