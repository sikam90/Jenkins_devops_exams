pipeline {
    agent any

    environment {
        APP_NAME = "Jenkins_devops_exams"
        SERVICES = "cast-service,movie-service,nginx"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Récupération du code source..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Construction de l'image Docker..."
                sh 'docker build -t ${APP_NAME}:latest .'
            }
        }

        stage('Run Tests') {
            steps {
                echo "Exécution des tests..."
                sh 'chmod +x test.sh && ./test.sh'
            }
        }

        stage('Deploy to Dev') {
            steps {
                echo "Déploiement sur environnement DEV..."
                sh 'chmod +x deploy-dev.sh && ./deploy-dev.sh'
            }
        }

        stage('Deploy to QA') {
            when {
                branch 'qa'
            }
            steps {
                echo "Déploiement sur environnement QA..."
                sh 'chmod +x deploy-qa.sh && ./deploy-qa.sh'
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'staging'
            }
            steps {
                echo "Déploiement sur environnement STAGING..."
                sh 'chmod +x deploy-staging.sh && ./deploy-staging.sh'
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'master'
            }
            steps {
                echo "Déploiement sur environnement PROD..."
                sh 'chmod +x deploy-prod.sh && ./deploy-prod.sh'
            }
        }
    }

    post {
        success {
            echo "Pipeline terminé avec succès ✅"
        }
        failure {
            echo "Échec du pipeline ❌"
        }
    }
}
