#!/bin/bash
set -e

echo "Déploiement sur l'environnement DEV..."

kubectl --kubeconfig=$KUBECONFIG apply -f k8s/dev/nginx-deployment.yaml
kubectl --kubeconfig=$KUBECONFIG apply -f k8s/dev/cast-service-deployment.yaml
kubectl --kubeconfig=$KUBECONFIG apply -f k8s/dev/movie-service-deployment.yaml

echo "Déploiement DEV terminé."
