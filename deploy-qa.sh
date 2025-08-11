#!/bin/bash
echo "Déploiement sur l'environnement QA..."

# Export kubeconfig si nécessaire
export KUBECONFIG=/chemin/vers/ton/kubeconfig

kubectl apply -f k8s/qa-deployment.yaml

echo "Déploiement QA terminé."
