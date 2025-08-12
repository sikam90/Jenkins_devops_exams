pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE_CAST = "ton_dockerhub_user/cast-service"
        DOCKER_IMAGE_MOVIE = "ton_dockerhub_user/movie-service"
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

        stage('Unit Tests - Cast Service') {
            steps {
                dir('cast-service') {
                    sh '''
                    echo "Running Unit Tests for Cast Service..."
                    chmod +x test.sh
                    ./test.sh --unit
                    '''
                }
            }
        }

        stage('Unit Tests - Movie Service') {
            steps {
                dir('movie-service') {
                    sh '''
                    echo "Running Unit Tests for Movie Service..."
                    chmod +x test.sh
                    ./test.sh --unit
                    '''
                }
            }
        }

        stage('Acceptance Tests - Cast Service') {
            steps {
                dir('cast-service') {
                    sh '''
                    echo "Running Acceptance Tests for Cast Service..."
                    chmod +x test.sh
                    ./test.sh --acceptance
                    '''
                }
            }
        }

        stage('Acceptance Tests - Movie Service') {
            steps {
                dir('movie-service') {
                    sh '''
                    echo "Running Acceptance Tests for Movie Service..."
                    chmod +x test.sh
                    ./test.sh --acceptance
                    '''
                }
            }
        }

        stage('Build & Push Docker Images') {
            parallel {
                stage('Cast Service') {
                    steps {
                        sh '''
                        echo "Building Docker Image for Cast Service..."
                        docker build -t $DOCKER_IMAGE_CAST:$BUILD_NUMBER cast-service
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker push $DOCKER_IMAGE_CAST:$BUILD_NUMBER
                        '''
                    }
                }
                stage('Movie Service') {
                    steps {
                        sh '''
                        echo "Building Docker Image for Movie Service..."
                        docker build -t $DOCKER_IMAGE_MOVIE:$BUILD_NUMBER movie-service
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker push $DOCKER_IMAGE_MOVIE:$BUILD_NUMBER
                        '''
                    }
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                sh '''
                echo "Deploying to Dev Environment..."
                chmod +x deploy-dev.sh
                ./deploy-dev.sh $DOCKER_IMAGE_CAST:$BUILD_NUMBER $DOCKER_IMAGE_MOVIE:$BUILD_NUMBER
                '''
            }
        }

        stage('Deploy to QA') {
            when { branch 'dev' }
            steps {
                sh '''
                echo "Deploying to QA Environment..."
                chmod +x deploy-qa.sh
                ./deploy-qa.sh $DOCKER_IMAGE_CAST:$BUILD_NUMBER $DOCKER_IMAGE_MOVIE:$BUILD_NUMBER
                '''
            }
        }

        stage('Deploy to Staging') {
            when { branch 'dev' }
            steps {
                sh '''
                echo "Deploying to Staging Environment..."
                chmod +x deploy-staging.sh
                ./deploy-staging.sh $DOCKER_IMAGE_CAST:$BUILD_NUMBER $DOCKER_IMAGE_MOVIE:$BUILD_NUMBER
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
                ./deploy-prod.sh $DOCKER_IMAGE_CAST:$BUILD_NUMBER $DOCKER_IMAGE_MOVIE:$BUILD_NUMBER
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
