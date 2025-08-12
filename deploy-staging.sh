#!/bin/bash
echo "Déploiement sur l'environnement Staging..."

export KUBECONFIG=/chemin/vers/ton/kubeconfig

kubectl apply -f k8s/staging-deployment.yaml

echo "Déploiement Staging terminé."
