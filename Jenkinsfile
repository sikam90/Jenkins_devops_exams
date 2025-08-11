pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://ton-repo-git.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh './build.sh'
            }
        }
        stage('Test') {
            steps {
                sh './run-tests.sh'
            }
        }
        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
