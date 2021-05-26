#!/usr/bin/env bash

DOCKER_ID=$1
if [[ -z "$DOCKER_ID" ]]; then
    echo "Usage is: ./build.sh <your-dockerhub-id>"
    exit 1
fi

echo "Building the app ..."
docker build -t email-parse:latest .
docker tag email-parse:latest ${DOCKER_ID}/email-parse:latest

echo "Pushing the app to the repo ..."
docker push ${DOCKER_ID}/email-parse:latest
if [[ $? -ne 0 ]]; then
    echo "If you received a permissions error on push, please make sure you are logged into your docker account with 'docker login'"
    exit 1
else
    exit 0
fi
