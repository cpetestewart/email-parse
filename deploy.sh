#!/usr/bin/env bash

DOCKER_ID=$1
DOCKER_CONFIG=~/.docker/config.json
if [[ -z "$DOCKER_ID" ]]; then
    echo "Usage is: ./deploy.sh <your-dockerhub-id>"
    exit 1
fi
if [[ ! -f $DOCKER_CONFIG ]]; then
    echo "No $DOCKER_CONFIG found - please log into your docker hub account first"
    exit 1
fi

echo "Creeating the namsapce and service account ..."
kubectl apply -f ns_and_sa.yaml

echo "Creating the docker credentials secret ..."
kubectl -n email-parse create secret generic docker-credentials \
    --from-file=.dockerconfigjson=$DOCKER_CONFIG \
    --type=kubernetes.io/dockerconfigjson
if [[ $? -ne 0 ]]; then
    echo "If you got an error comaplaining about a namespace not found, make sure you applied the ns_and_sa.yaml deployment file"
    exit 1
fi

echo "Deploying the application ..."
sed "s/yourdockerhubid/$DOCKER_ID/g" deployment.yaml > custom_deployment.yaml
kubectl apply -f custom_deployment.yaml

echo "Done."
exit 0