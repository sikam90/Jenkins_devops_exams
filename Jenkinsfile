pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
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
                        echo "Build Docker image for ${service}"
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
                            echo "Push Docker image for ${service}"
                            docker.image("${DOCKER_REPO}/${service}:latest").push()
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Nettoyage des ressources Docker temporaires...'
            sh 'docker system prune -f || true'
        }
    }
}
