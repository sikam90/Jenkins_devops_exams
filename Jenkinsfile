pipeline {
    agent any

    environment {
        // Déclare ici tes credentials si besoin (exemple)
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-id')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code source depuis la branche dev'
                checkout([$class: 'GitSCM', 
                    branches: [[name: 'refs/heads/dev']], 
                    userRemoteConfigs: [[url: 'https://github.com/sikam90/Jenkins_devops_exams.git']]
                ])
            }
        }

        stage('Run Unit Tests - Cast Service') {
            steps {
                echo 'Lancement des tests unitaires Cast Service'
                // ici la commande de test, exemple:
                // sh 'cd cast-service && ./run-tests.sh'
            }
        }

        stage('Run Acceptance Tests - Cast Service') {
            steps {
                echo 'Lancement des tests d\'acceptation Cast Service'
                // sh 'cd cast-service && ./run-acceptance-tests.sh'
            }
        }

        stage('Run Unit Tests - Movie Service') {
            steps {
                echo 'Lancement des tests unitaires Movie Service'
                // sh 'cd movie-service && ./run-tests.sh'
            }
        }

        stage('Run Acceptance Tests - Movie Service') {
            steps {
                echo 'Lancement des tests d\'acceptation Movie Service'
                // sh 'cd movie-service && ./run-acceptance-tests.sh'
            }
        }

        stage('Build Docker Images') {
            steps {
                echo 'Construction des images Docker'
                // sh 'docker build -t cast-service:latest ./cast-service'
                // sh 'docker build -t movie-service:latest ./movie-service'
            }
        }

        stage('Push Docker Images') {
            steps {
                echo 'Push des images Docker vers Docker Hub'
                // withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                //     sh 'docker login -u $USERNAME -p $PASSWORD'
                //     sh 'docker push cast-service:latest'
                //     sh 'docker push movie-service:latest'
                // }
            }
        }

        stage('Deploy to Dev Environment') {
            steps {
                echo 'Déploiement en environnement de développement'
                // sh './deploy-dev.sh'
            }
        }

        stage('Deploy to QA Environment') {
            steps {
                echo 'Déploiement en environnement QA'
                // sh './deploy-qa.sh'
            }
        }

        stage('Deploy to Staging Environment') {
            steps {
                echo 'Déploiement en staging'
                // sh './deploy-staging.sh'
            }
        }

        stage('Deploy to Production Environment') {
            steps {
                echo 'Déploiement en production'
                // sh './deploy-production.sh'
            }
        }
    }

    post {
        failure {
            echo 'Pipeline échoué. Vérifiez les logs.'
        }
        success {
            echo 'Pipeline terminé avec succès.'
        }
    }
}
