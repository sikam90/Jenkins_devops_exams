pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                // ici commandes de build
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                // ici commandes de test
            }
        }

        stage('Deploy to Dev') {
            steps {
                echo 'Deploying to dev environment...'
                sh 'kubectl apply -f k8s/dev/deployment.yaml -n dev'
            }
        }

        stage('Deploy to Prod') {
            when {
                branch 'master'
            }
            steps {
                input message: 'Déployer en production ?'
                echo 'Deploying to production environment...'
                sh 'kubectl apply -f k8s/prod/deployment.yaml -n prod'
            }
        }
    }
}

