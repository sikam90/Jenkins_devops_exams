pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-credentials-id')
        GIT_REPO = "https://github.com/sikam90/Jenkins_devops_exams.git"
        CAST_IMAGE = "sikam/cast-service"
        MOVIE_IMAGE = "sikam/movie-service"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Récupération du code source"
                git url: "${env.GIT_REPO}", branch: "${env.BRANCH_NAME}"
            }
        }

        stage('Run Unit Tests - Cast Service') {
            steps {
                echo "Tests unitaires du cast-service"
                dir('cast-service') {
                    sh './mvnw test'
                }
            }
        }

        stage('Run Acceptance Tests - Cast Service') {
            steps {
                echo "Tests d’acceptation du cast-service"
                dir('cast-service') {
                    sh './mvnw verify -Pacceptance-tests'
                }
            }
        }

        stage('Run Unit Tests - Movie Service') {
            steps {
                echo "Tests unitaires du movie-service"
                dir('movie-service') {
                    sh './mvnw test'
                }
            }
        }

        stage('Run Acceptance Tests - Movie Service') {
            steps {
                echo "Tests d’acceptation du movie-service"
                dir('movie-service') {
                    sh './mvnw verify -Pacceptance-tests'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    echo "Construction des images Docker"
                    dockerCast = docker.build("${CAST_IMAGE}:${env.BRANCH_NAME}-${env.BUILD_NUMBER}", "cast-service/")
                    dockerMovie = docker.build("${MOVIE_IMAGE}:${env.BRANCH_NAME}-${env.BUILD_NUMBER}", "movie-service/")
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials-id') {
                        echo "Push de l'image cast-service"
                        dockerCast.push()
                        dockerCast.push('latest')

                        echo "Push de l'image movie-service"
                        dockerMovie.push()
                        dockerMovie.push('latest')
                    }
                }
            }
        }

        stage('Deploy to Dev Environment') {
            when {
                branch 'dev'
            }
            steps {
                echo "Déploiement automatique en DEV"
                withCredentials([file(credentialsId: 'kubeconfig-credentials-id', variable: 'KUBECONFIG_FILE')]) {
                    sh """
                        export KUBECONFIG=${KUBECONFIG_FILE}
                        kubectl apply -n dev -f k8s/dev/cast-deployment.yaml
                        kubectl apply -n dev -f k8s/dev/movie-deployment.yaml
                    """
                }
            }
        }

        stage('Deploy to QA Environment') {
            when {
                branch 'qa'
            }
            steps {
                echo "Déploiement automatique en QUALIFICATION"
                withCredentials([file(credentialsId: 'kubeconfig-credentials-id', variable: 'KUBECONFIG_FILE')]) {
                    sh """
                        export KUBECONFIG=${KUBECONFIG_FILE}
                        kubectl apply -n qa -f k8s/qa/cast-deployment.yaml
                        kubectl apply -n qa -f k8s/qa/movie-deployment.yaml
                    """
                }
            }
        }

        stage('Deploy to Staging Environment') {
            when {
                branch 'staging'
            }
            steps {
                echo "Déploiement automatique en STAGING"
                withCredentials([file(credentialsId: 'kubeconfig-credentials-id', variable: 'KUBECONFIG_FILE')]) {
                    sh """
                        export KUBECONFIG=${KUBECONFIG_FILE}
                        kubectl apply -n staging -f k8s/staging/cast-deployment.yaml
                        kubectl apply -n staging -f k8s/staging/movie-deployment.yaml
                    """
                }
            }
        }

        stage('Deploy to Production Environment') {
            when {
                branch 'master'
            }
            steps {
                input message: "Confirmer le déploiement en production ?", ok: "Déployer"
                echo "Déploiement manuel en PRODUCTION"
                withCredentials([file(credentialsId: 'kubeconfig-credentials-id', variable: 'KUBECONFIG_FILE')]) {
                    sh """
                        export KUBECONFIG=${KUBECONFIG_FILE}
                        kubectl apply -n prod -f k8s/prod/cast-deployment.yaml
                        kubectl apply -n prod -f k8s/prod/movie-deployment.yaml
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline terminé avec succès."
        }
        failure {
            echo "Pipeline échoué. Vérifiez les logs."
        }
    }
}
