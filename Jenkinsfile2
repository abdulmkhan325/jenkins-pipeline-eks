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
        // Checkout code from Git repository
        stage('Enviroment Variables') {
            steps {
                sh """
                    ls
                """.stripIndent()
            }
        }
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
        // Ansible Install and Check
        stage('Install Dependencies') {
            steps {
                sh """
                    sudo yum install ansible -y
                    sudo yum install docker -y 
                    ansible --version
                    docker --version  
                    """.stripIndent()  
            }
        } 
        // Setup Docker 
        // stage('Docker Setup and Start it') {
        //     steps {
        //         sh  """
        //             if getent group docker >/dev/null; then  
        //                 echo "docker group exists"  
        //                 sudo usermod -aG docker jenkins
        //             else  
        //                 echo "docker group does not exist."
        //                 sudo groupadd docker
        //                 sudo usermod -aG docker jenkins
        //             fi
        //             """.stripIndent()
                   
        //     }
        // }
        // Rosa Download and Install
        stage('ROSA Download and Install') {
            steps {
                script {
                    // Check if rosa command exists
                    def rosaCommand = sh(script: 'rosa', returnStatus: true)  
                    println "this is print ln output = ${rosaCommand}"
                    if (rosaCommand == 127) {
                        sh """
                            wget https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz
                            tar xvf rosa-linux.tar.gz 
                            sudo mv rosa /usr/local/bin/rosa
                           """.stripIndent()
                    } else {
                        sh "rosa version"
                    }
                }
            }  
        } 
        // Rosa Login
        stage('ROSA Login') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh """  
                        rosa login --region=ap-southeast-2 --token="${ROSA_TOKEN}"
                        rosa whoami --region=ap-southeast-2
                    """.stripIndent()
                }
            }
        }  
        // Docker login
        stage("Docker Login"){
            steps { 
                sh """
                    docker login -u ${dockerUserName} -p ${DOCKER_PASS}   
                """
            }
        }
        // Docker build
        stage("Docker Build"){
            steps {    
                sh """
                    cd react-app  
                    ls
                    docker build -t ${dockerImage} .      
                """
            }
        }
        // Docker Tag
        stage("Docker Tag"){
            steps { 
                sh """
                    docker tag ${dockerImage} abdulmkhan325/github-projects:${dateStamp}   
                """
            }
        }
        // Docker Push
        stage("Docker Push"){
            steps { 
                sh """
                    docker push abdulmkhan325/github-projects:${dateStamp}     
                """
            }
        }
    }
}