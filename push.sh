#!/bin/bash
set -e

echo "Connexion à DockerHub..."
docker login -u "$DOCKER_USER" -p "$DOCKER_PASS"

echo "Push des images Docker..."

docker push sikam/jenkins-devops-exam:nginx
docker push sikam/jenkins-devops-exam:cast-service
docker push sikam/jenkins-devops-exam:movie-service

echo "Images poussées sur DockerHub."
