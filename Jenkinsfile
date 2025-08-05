pipeline {
  agent any

  environment {
    DOCKER_ID = "sikam"
    DOCKER_IMAGE = "jenkins-devops-exam"
    DOCKER_TAG = "v.${BUILD_ID}.0"
    KUBECONFIG = '/var/lib/jenkins/kubeconfig'
  }

  stages {
    stage('Test Kubeconfig') {
      steps {
        sh 'kubectl get pods -n dev'
      }
    }
  }
}

