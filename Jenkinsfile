pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKERHUB_USER = "ton_dockerhub_user"
        IMAGE_PREFIX = "ton_dockerhub_user/app"
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig')
    }

    options {
        disableConcurrentBuilds()
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/sikam90/Jenkins_devops_exams.git'
            }
        }

        stage('Unit Tests') {
            parallel {
                stage('Movie Service Tests') {
                    steps {
                        sh 'cd movie-service && pytest --maxfail=1 --disable-warnings -q'
                    }
                }
                stage('Cast Service Tests') {
                    steps {
                        sh 'cd cast-service && pytest --maxfail=1 --disable-warnings -q'
                    }
                }
                stage('Web Service Tests') {
                    steps {
                        sh 'cd web && npm install && npm run test'
                    }
                }
            }
        }

        stage('Acceptance Tests') {
            steps {
                sh './test.sh'
            }
        }

        stage('Build & Push Docker Images') {
            parallel {
                stage('Movie Service') {
                    steps {
                        sh '''
                        docker build -t $IMAGE_PREFIX-movie-service:latest ./movie-service
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_USER --password-stdin
                        docker push $IMAGE_PREFIX-movie-service:latest
                        '''
                    }
                }
                stage('Cast Service') {
                    steps {
                        sh '''
                        docker build -t $IMAGE_PREFIX-cast-service:latest ./cast-service
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_USER --password-stdin
                        docker push $IMAGE_PREFIX-cast-service:latest
                        '''
                    }
                }
                stage('Web Service') {
                    steps {
                        sh '''
                        docker build -t $IMAGE_PREFIX-web:latest ./web
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_USER --password-stdin
                        docker push $IMAGE_PREFIX-web:latest
                        '''
                    }
                }
                stage('NGINX') {
                    steps {
                        sh '''
                        docker build -t $IMAGE_PREFIX-nginx:latest ./nginx
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_USER --password-stdin
                        docker push $IMAGE_PREFIX-nginx:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG_FILE
                    kubectl apply -f namespaces.yaml
                    kubectl apply -f k8s/dev
                    '''
                }
            }
        }

        stage('Deploy to QA') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG_FILE
                    ./deploy-qa.sh
                    '''
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG_FILE
                    ./deploy-staging.sh
                    '''
                }
            }
        }

        stage('Manual Approval for Production') {
            when {
                branch 'master'
            }
            steps {
                input message: 'Deploy to Production?', ok: 'Deploy'
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'master'
            }
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG_FILE
                    ./deploy-prod.sh
                    '''
                }
            }
        }
    }

    post {
        always {
            junit '**/test-results.xml'
            cleanWs()
        }
    }
}
