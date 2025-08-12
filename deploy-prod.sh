#!/bin/bash
echo "Déploiement sur l'environnement Production..."

export KUBECONFIG=/chemin/vers/ton/kubeconfig

kubectl apply -f k8s/prod-deployment.yaml

echo "Déploiement Production terminé."
