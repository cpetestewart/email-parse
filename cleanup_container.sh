#!/usr/bin/env bash

CONTAINER_ID=$(docker container ps | grep email-parse | awk '{ print $1 }')
if [[ -z "$CONTAINER_ID" ]]; then
    echo "No container found for email-parse"
    exit 0
fi

echo "Rmeoving container $CONTAINER_ID ..."
docker container kill $CONTAINER_ID