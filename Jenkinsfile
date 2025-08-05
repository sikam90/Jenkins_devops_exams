pipeline {
    agent any

    environment {
        KUBECONFIG = '/var/lib/jenkins/kubeconfig'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test kubectl') {
            steps {
                sh 'kubectl get pods -n dev'
            }
        }
    }
}

