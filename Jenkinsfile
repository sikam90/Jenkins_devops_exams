pipeline {
    agent any
    
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Construction des images Docker...'
                // Ici, tu mets les commandes de build docker, exemple : sh 'docker build -t myimage:latest .'
            }
        }

        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        script {
                            if (fileExists('./run_tests_cast.sh')) {
                                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                                    sh './run_tests_cast.sh'
                                }
                            } else {
                                echo "run_tests_cast.sh non trouvé."
                            }
                        }
                    }
                }
                stage('Acceptance Tests') {
                    steps {
                        echo 'Exécution des tests d’acceptation (placeholder).'
                        // sh './run_acceptance_tests.sh' ou autre
                    }
                }
            }
        }

        stage('Push') {
            steps {
                echo 'Pousser les images Docker sur DockerHub...'
                // sh 'docker push myimage:latest'
            }
        }

        stage('Deploy Dev') {
            steps {
                echo 'Déploiement automatique en Dev...'
                // commande déploiement dev
            }
        }

        stage('Deploy QA') {
            steps {
                echo 'Déploiement automatique en QA...'
                // commande déploiement qa
            }
        }

        stage('Deploy Staging') {
            steps {
                echo 'Déploiement automatique en Staging...'
                // commande déploiement staging
            }
        }

        stage('Deploy Production') {
            when {
                branch 'master'
            }
            steps {
                input message: 'Déploiement en production ? Confirmes-tu ?', ok: 'Oui'
                echo 'Déploiement manuel en production...'
                // commande déploiement prod
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
        failure {
            echo 'Pipeline échoué, vérifier les logs.'
        }
    }
}

