pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        KUBECONFIG = credentials('kubeconfig')
        DOCKER_REPO = "sikam"
        SERVICES = ["cast-service", "movie-service", "nginx"]
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/sikam90/Jenkins_devops_exams.git'
            }
        }

        stage('Build images') {
            steps {
                script {
                    SERVICES.each { service ->
                        echo "Building image for ${service}"
                        docker.build("${DOCKER_REPO}/${service}:latest", "./${service}")
                    }
                }
            }
        }

        stage('Push images') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        SERVICES.each { service ->
                            echo "Pushing image ${DOCKER_REPO}/${service}:latest"
                            docker.image("${DOCKER_REPO}/${service}:latest").push()
                        }
                    }
                }
            }
        }

        stage('Deploy to Qualification') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    echo "Deploying to qualification environment"
                    sh 'kubectl apply -f k8s/qualification/'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                input message: 'Valider le déploiement en production ?', ok: 'Déployer'
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    echo "Deploying to production environment"
                    sh 'kubectl apply -f k8s/production/'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up docker resources'
            sh 'docker system prune -f || true'
        }
    }
}
