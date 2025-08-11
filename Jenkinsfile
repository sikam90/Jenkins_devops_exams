pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/sikam90/Jenkins_devops_exams.git', branch: 'staging'
            }
        }

        stage('Build') {
            steps {
                echo 'Building...'
                // Ajoute ici tes commandes de build si besoin
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                // Ajoute ici tes commandes de test si besoin
            }
        }

        stage('Deploy to Dev') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-dev', variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f k8s/dev/ -n dev --kubeconfig=$KUBECONFIG'
                }
            }
        }
    }
}
