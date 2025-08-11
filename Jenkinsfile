pipeline {
    agent any
    environment {
        KUBECONFIG = '/var/lib/jenkins/.kube/config'  // chemin correct pour Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/sikam90/Jenkins_devops_exams.git', branch: 'staging'
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy to Dev') {
            steps {
                echo 'Deploying all services to dev environment...'
                sh 'kubectl apply -f k8s/dev/ -n dev'
            }
        }
    }
}
