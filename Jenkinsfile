pipeline {
    agent any

    environment {
        // Noms en minuscules pour Docker
        APP_NAME = "jenkins_devops_exams"
        SERVICES = "cast-service,movie-service,nginx"
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        skipDefaultCheckout true
    }

    stages {
        stage('Checkout') {
            steps {
                echo "📥 Clonage du dépôt une seule fois..."
                checkout scm
            }
        }

        stage('Build Services in Parallel') {
            steps {
                script {
                    def serviceList = SERVICES.split(',')
                    def buildStages = serviceList.collectEntries { service ->
                        ["Build ${service}": {
                            stage("Build ${service}") {
                                echo "🔨 Construction de l'image Docker pour ${service}..."
                                try {
                                    // Supprimer ancienne image si existante (ignore erreur)
                                    sh "docker image rm -f ${service.toLowerCase()}:latest || true"
                                    // Build image Docker depuis le répertoire du service
                                    sh "docker build -t ${service.toLowerCase()}:latest ./${service}"
                                } catch (err) {
                                    error("Erreur lors du build Docker pour ${service} : ${err}")
                                }
                            }
                        }]
                    }
                    parallel buildStages
                }
            }
        }

        stage('Unit Tests') {
            steps {
                echo "🧪 Exécution des tests unitaires..."
                sh 'chmod +x test.sh && ./test.sh unit || exit 1'
            }
        }

        stage('Acceptance Tests') {
            steps {
                echo "✅ Exécution des tests d’acceptance..."
                sh 'chmod +x test.sh && ./test.sh acceptance || exit 1'
            }
        }

        stage('Deploy to Environments') {
            parallel {
                stage('Deploy to QA') {
                    when { branch 'qa' }
                    steps {
                        echo "🚀 Déploiement sur QA..."
                        sh 'chmod +x deploy-qa.sh && ./deploy-qa.sh'
                    }
                }
                stage('Deploy to Staging') {
                    when { branch 'staging' }
                    steps {
                        echo "🚀 Déploiement sur STAGING..."
                        sh 'chmod +x deploy-staging.sh && ./deploy-staging.sh'
                    }
                }
                stage('Deploy to Production') {
                    when { branch 'master' }
                    steps {
                        echo "🚀 Déploiement sur PROD..."
                        sh 'chmod +x deploy-prod.sh && ./deploy-prod.sh'
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminé avec succès !"
        }
        failure {
            echo "❌ Le pipeline a échoué."
            // Ici tu peux ajouter notifications, emails, slack, etc.
        }
        always {
            cleanWs()
        }
    }
}

