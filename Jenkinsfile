pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                // tes étapes de build ici
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                // tes étapes de test ici
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
                sh 'kubectl apply -f k8s/prod/deployment.yaml -n prod'
            }
        }
    }
}

