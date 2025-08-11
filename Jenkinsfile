pipeline {
    agent any
    environment {
        KUBECONFIG = '/home/ubuntu/.kube/config' // adapte selon ton chemin kubeconfig
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
                // Ici tu peux mettre tes commandes de build si besoin
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                // Ici tes tests
            }
        }
        stage('Deploy to Dev') {
            steps {
                echo 'Deploying to dev environment...'
                sh 'kubectl apply -f k8s/dev/deployment.yaml -n dev'
            }
        }
    }
}
