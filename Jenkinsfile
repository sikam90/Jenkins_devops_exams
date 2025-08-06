pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                // Ajoute ici tes commandes de build (docker build, etc)
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                // Ajoute ici tes commandes de test (unit tests, lint, etc)
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
