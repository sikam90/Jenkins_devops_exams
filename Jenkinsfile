pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_PASS')  // Ton token/mot de passe DockerHub
        KUBECONFIG = credentials('config')                      // Ton fichier kubeconfig
        IMAGE_NAME = 'sikam/myapp-fastapi'                      // Remplace par ton repo DockerHub
        GIT_BRANCH = "${env.BRANCH_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME:$GIT_BRANCH .'
                }
            }
        }

        stage('Login DockerHub') {
            steps {
                script {
                    sh """
                    echo $DOCKER_HUB_CREDENTIALS_PSW | docker login --username sikam --password-stdin
                    """
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    sh 'docker push $IMAGE_NAME:$GIT_BRANCH'
                }
            }
        }

        stage('Deploy to Kubernetes DEV') {
            steps {
                script {
                    // Utilisation du kubeconfig
                    writeFile file: 'kubeconfig', text: KUBECONFIG
                    sh 'kubectl --kubeconfig=kubeconfig -n dev set image deployment/app-fastapi app-fastapi=$IMAGE_NAME:$GIT_BRANCH'
                    sh 'kubectl --kubeconfig=kubeconfig -n dev rollout status deployment/app-fastapi'
                }
            }
        }

        stage('Deploy to Kubernetes QA') {
            steps {
                script {
                    sh 'kubectl --kubeconfig=kubeconfig -n qa set image deployment/app-fastapi app-fastapi=$IMAGE_NAME:$GIT_BRANCH'
                    sh 'kubectl --kubeconfig=kubeconfig -n qa rollout status deployment/app-fastapi'
                }
            }
        }

        stage('Deploy to Kubernetes STAGING') {
            steps {
                script {
                    sh 'kubectl --kubeconfig=kubeconfig -n staging set image deployment/app-fastapi app-fastapi=$IMAGE_NAME:$GIT_BRANCH'
                    sh 'kubectl --kubeconfig=kubeconfig -n staging rollout status deployment/app-fastapi'
                }
            }
        }

        stage('Manual Approval for Production') {
            when {
                branch 'master'
            }
            steps {
                input message: 'Approve deployment to production?', ok: 'Deploy'
            }
        }

        stage('Deploy to Kubernetes PROD') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sh 'kubectl --kubeconfig=kubeconfig -n prod set image deployment/app-fastapi app-fastapi=$IMAGE_NAME:$GIT_BRANCH'
                    sh 'kubectl --kubeconfig=kubeconfig -n prod rollout status deployment/app-fastapi'
                }
            }
        }
    }
}

