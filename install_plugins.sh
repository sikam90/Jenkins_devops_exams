#!/bin/bash

JENKINS_URL="http://localhost:8080"
USER="sikam"
TOKEN="119b76f5619c564fa3ca9b23570d1b158b"

PLUGINS=(
  github
  docker-workflow
  kubernetes-cli
  pipeline-stage-view
  workflow-aggregator
)

for plugin in "${PLUGINS[@]}"; do
  echo "Installation du plugin : $plugin"
  java -jar jenkins-cli.jar -s $JENKINS_URL -auth $USER:$TOKEN install-plugin $plugin -deploy
done

