pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'qa', 'prod'], description: 'Choisir l\'environnement de déploiement')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Tag de l\'image Docker')
    }

    environment {
        DOCKER_REGISTRY = 'monregistry.example.com'
        HELM_RELEASE = "monapp-${params.ENV}"
        HELM_NAMESPACE = "${params.ENV}"
        CHART_DIR = 'charts/monapp'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh './build.sh'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh './run-unit-tests.sh'
            }
            post {
                always {
                    junit 'tests/unit-results.xml'
                }
            }
        }

        stage('Run Acceptance Tests') {
            steps {
                sh './run-acceptance-tests.sh'
            }
            post {
                always {
                    junit 'tests/acceptance-results.xml'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh './push.sh'
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh """
                   helm upgrade --install ${HELM_RELEASE} ${CHART_DIR} \
                   --namespace ${HELM_NAMESPACE} --create-namespace \
                   --set image.tag=${params.IMAGE_TAG} \
                   --values values-${params.ENV}.yaml
                """
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminé avec succès pour l'environnement ${params.ENV}"
        }
        failure {
            echo "❌ Le pipeline a échoué"
        }
    }
}
