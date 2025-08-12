pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'your-docker-registry'   // à remplacer par ton registry si besoin
        IMAGE_NAME_CAST = 'cast-service'
        IMAGE_NAME_MOVIE = 'movie-service'
        IMAGE_NAME_NGINX = 'nginx'
        K8S_NAMESPACE_QA = 'qa'
        K8S_NAMESPACE_STAGING = 'staging'
        K8S_NAMESPACE_PROD = 'prod'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test Cast Service') {
            steps {
                dir('cast-service') {
                    sh './test.sh unit'
                    sh 'docker build -t $DOCKER_REGISTRY/$IMAGE_NAME_CAST:latest .'
                }
            }
        }

        stage('Build & Test Movie Service') {
            steps {
                dir('movie-service') {
                    sh './test.sh unit'
                    sh 'docker build -t $DOCKER_REGISTRY/$IMAGE_NAME_MOVIE:latest .'
                }
            }
        }

        stage('Build & Test Nginx') {
            steps {
                dir('nginx') {
                    sh './test.sh acceptance'
                    sh 'docker build -t $DOCKER_REGISTRY/$IMAGE_NAME_NGINX:latest .'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME_CAST:latest"
                sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME_MOVIE:latest"
                sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME_NGINX:latest"
            }
        }

        stage('Deploy to QA') {
            steps {
                sh './deploy-qa.sh'
            }
        }

        stage('Deploy to Staging') {
            steps {
                input message: 'Deploy to Staging?', ok: 'Yes'
                sh './deploy-staging.sh'
            }
        }

        stage('Deploy to Production') {
            steps {
                input message: 'Deploy to Production?', ok: 'Yes'
                sh './deploy-prod.sh'
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
        failure {
            mail to: 'ton.email@domaine.com',
                 subject: "Échec du pipeline Jenkins: ${currentBuild.fullDisplayName}",
                 body: "Le build a échoué. Voir les logs : ${env.BUILD_URL}"
        }
    }
}
