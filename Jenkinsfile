pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa', 'prod'], description: 'Choisir l’environnement de déploiement')
    }

    environment {
        DOCKER_REGISTRY = "docker.io/moncompte" // À modifier
        IMAGE_TAG = "${params.ENV}-${env.BUILD_NUMBER}"
        KUBECONFIG = credentials('kubeconfig-id') // ID Jenkins Credential
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test Services') {
            parallel {
                stage('Cast Service') {
                    steps {
                        script {
                            buildAndTestService('cast-service')
                        }
                    }
                }
                stage('Movie Service') {
                    steps {
                        script {
                            buildAndTestService('movie-service')
                        }
                    }
                }
            }
        }

        stage('Acceptance Tests') {
            steps {
                dir('tests/acceptance') {
                    sh 'chmod +x run-acceptance-tests.sh'
                    sh './run-acceptance-tests.sh'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-id', url: '']) {
                    sh "docker push $DOCKER_REGISTRY/cast-service:${IMAGE_TAG}"
                    sh "docker push $DOCKER_REGISTRY/movie-service:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    if (params.ENV == 'dev') {
                        sh './deploy-dev.sh'
                    } else if (params.ENV == 'qa') {
                        sh './deploy-qa.sh'
                    } else if (params.ENV == 'prod') {
                        sh './deploy-prod.sh'
                    }
                }
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml' // Si tests Maven
        }
        success {
            echo "✅ Déploiement ${params.ENV} terminé avec succès"
        }
        failure {
            echo "❌ Le pipeline a échoué"
        }
    }
}

def buildAndTestService(serviceName) {
    dir(serviceName) {
        sh 'chmod +x run-unit-tests.sh'
        sh './run-unit-tests.sh'
        sh "docker build -t ${env.DOCKER_REGISTRY}/${serviceName}:${env.IMAGE_TAG} ."
    }
}
