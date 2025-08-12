pipeline {
    agent any

    environment {
        // Utilise le bon credential ID ici
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'
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
                // Place ici tes commandes de tests unitaires pour Cast Service
                sh './run_tests_cast.sh'  // Exemple de commande, adapte à ton projet
            }
        }

        stage('Run Acceptance Tests - Cast Service') {
            steps {
                echo 'Exécution des tests d\'acceptation pour Cast Service'
                sh './run_acceptance_tests_cast.sh' // Exemple
            }
        }

        stage('Run Unit Tests - Movie Service') {
            steps {
                echo 'Exécution des tests unitaires pour Movie Service'
                sh './run_tests_movie.sh' // Exemple
            }
        }

        stage('Run Acceptance Tests - Movie Service') {
            steps {
                echo 'Exécution des tests d\'acceptation pour Movie Service'
                sh './run_acceptance_tests_movie.sh' // Exemple
            }
        }

        stage('Build Docker Images') {
            steps {
                echo 'Construction des images Docker'
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh 'docker build -t sikam90/cast-service:latest ./cast-service'
                        sh 'docker build -t sikam90/movie-service:latest ./movie-service'
                    }
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                echo 'Push des images Docker sur Docker Hub'
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh 'docker push sikam90/cast-service:latest'
                        sh 'docker push sikam90/movie-service:latest'
                    }
                }
            }
        }

        stage('Deploy to Dev Environment') {
            steps {
                echo 'Déploiement en environnement Dev'
                // Ajoute ici ton script ou commandes pour déployer en Dev
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
