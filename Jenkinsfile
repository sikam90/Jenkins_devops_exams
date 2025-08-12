pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    GITHUB_CREDENTIALS = credentials('github-credentials')
    KUBECONFIG = credentials('kubeconfig')
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
          docker.build("sikam/cast-service:latest", "./cast-service")
          docker.build("sikam/movie-service:latest", "./movie-service")
          docker.build("sikam/nginx:latest", "./nginx")
        }
      }
    }

    stage('Test') {
      steps {
        echo 'Tests unitaires à ajouter selon projet'
      }
    }

    stage('Push images') {
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
            docker.image("sikam/cast-service:latest").push()
            docker.image("sikam/movie-service:latest").push()
            docker.image("sikam/nginx:latest").push()
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'kubectl apply -f k8s/dev/'
        }
      }
    }
  }
}

