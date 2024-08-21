pipeline {
    
    agent any

    stages {
        stage('github-checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/terraform-code-for-azure']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Abdullahsystems/webapp.git']])
            }
        }
         stage('terra-ver') {
            steps {
                sh 'terraform version'
            }
        }
         stage('terra-init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('terra-plan') {
            steps {
                
                sh 'terraform plan'
            }
        }
        stage('terra-apply') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}
