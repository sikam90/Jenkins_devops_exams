#!/bin/bash
set -e

echo "Construction des images Docker..."

docker build -t sikam/jenkins-devops-exam:nginx ./nginx
docker build -t sikam/jenkins-devops-exam:cast-service ./cast-service
docker build -t sikam/jenkins-devops-exam:movie-service ./movie-service

echo "Images Docker construites."
