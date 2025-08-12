pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "ton_dockerhub_user/ton_app"
        GITHUB_REPO = "https://github.com/ton_user/Jenkins_devops_exams.git"
        K8S_NAMESPACE_DEV = "dev"
        K8S_NAMESPACE_QA = "qa"
        K8S_NAMESPACE_STAGING = "staging"
        K8S_NAMESPACE_PROD = "prod"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: "${GITHUB_REPO}"
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                echo "Running Unit Tests..."
                chmod +x test.sh
                ./test.sh --unit
                '''
            }
        }

        stage('Acceptance Tests') {
            steps {
                sh '''
                echo "Running Acceptance Tests..."
                chmod +x test.sh
                ./test.sh --acceptance
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo "Building Docker Image..."
                docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                echo "Pushing Docker Image to DockerHub..."
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }

        stage('Deploy to Dev') {
            steps {
                sh '''
                echo "Deploying to Dev Environment..."
                chmod +x deploy-dev.sh
                ./deploy-dev.sh $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }

        stage('Deploy to QA (Qualification)') {
            when { branch 'dev' }
            steps {
                sh '''
                echo "Deploying to QA Environment..."
                chmod +x deploy-qa.sh
                ./deploy-qa.sh $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }

        stage('Deploy to Staging') {
            when { branch 'dev' }
            steps {
                sh '''
                echo "Deploying to Staging Environment..."
                chmod +x deploy-staging.sh
                ./deploy-staging.sh $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }

        stage('Deploy to Production') {
            when {
                allOf {
                    branch 'master'
                    expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
                }
            }
            steps {
                input message: 'Confirm deployment to PRODUCTION?', ok: 'Deploy'
                sh '''
                echo "Deploying to Production Environment..."
                chmod +x deploy-prod.sh
                ./deploy-prod.sh $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
