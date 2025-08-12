pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'
        DOCKER_IMAGE_PREFIX = 'sikam'  // Ton namespace Docker Hub
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code source'
                checkout scm
            }
        }

        stage('Run Unit Tests - Cast Service') {
            steps {
                echo 'Exécution des tests unitaires pour Cast Service'
                sh './run_tests_cast.sh'
            }
        }

        stage('Run Acceptance Tests - Cast Service') {
            steps {
                echo 'Exécution des tests d\'acceptation pour Cast Service'
                sh './run_acceptance_tests_cast.sh'
            }
        }

        stage('Run Unit Tests - Movie Service') {
            steps {
                echo 'Exécution des tests unitaires pour Movie Service'
                sh './run_tests_movie.sh'
            }
        }

        stage('Run Acceptance Tests - Movie Service') {
            steps {
                echo 'Exécution des tests d\'acceptation pour Movie Service'
                sh './run_acceptance_tests_movie.sh'
            }
        }

        stage('Build Docker Images') {
            steps {
                echo 'Construction des images Docker'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        sh "docker build -t ${DOCKER_IMAGE_PREFIX}/cast-service:latest ./cast-service"
                        sh "docker build -t ${DOCKER_IMAGE_PREFIX}/movie-service:latest ./movie-service"
                    }
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                echo 'Push des images Docker sur Docker Hub'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        sh "docker push ${DOCKER_IMAGE_PREFIX}/cast-service:latest"
                        sh "docker push ${DOCKER_IMAGE_PREFIX}/movie-service:latest"
                    }
                }
            }
        }

        stage('Deploy to Dev Environment') {
            steps {
                echo 'Déploiement en environnement Dev'
                sh './deploy_dev.sh'
            }
        }

        stage('Deploy to QA Environment') {
            steps {
                echo 'Déploiement en environnement QA'
                sh './deploy_qa.sh'
            }
        }

        stage('Deploy to Staging Environment') {
            steps {
                echo 'Déploiement en environnement Staging'
                sh './deploy_staging.sh'
            }
        }

        stage('Deploy to Production Environment') {
            steps {
                echo 'Déploiement en production'
                sh './deploy_production.sh'
            }
        }
    }

    post {
        success {
            echo 'Pipeline terminé avec succès.'
        }
        failure {
            echo 'Pipeline échoué. Vérifiez les logs.'
        }
    }
}
