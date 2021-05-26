# EMail Parse Application

## Summary

This application receives plain text email messages via POST and returns JSON data containing the following keys from the email header:

* To
* From
* Subject
* Date
* Message-ID

## Before you start

This will require hosting an image on docker hub so that a kubernetes cluster or minikube can have access to it. You will need a repository called "email-parse" in your account. Please use `docker login` in order to log into this account. You will need the credential file later for generating the proper secret.

Alternately, you can use a local docker site that you manage. In this case, create an "email-parse" repo in this site and use the base URL to that site wherever you are asked for your docker hub ID. For example, if you are using docker hub under the ID "johndoe" then you would specify that where needed:

`./build.sh johndoe`

But if you are instead hosting a local repo at "artifactory.mycompany.net/docker-repos", then specify that instead:

`./build.sh artifactory.mycompany.net/docker-repos`

You will still need to peform a `docker login` into your local repo prior to starting.

This document also assumes you are running from some flavor of Linux. All testing was done on Debian-based Linux distribution Linux Mint 20, docker version 20.10.2, kubernetes/minikube version 1.20.0.

## Building the application

To build and push the application, run the following command from this directory:

`./build.sh <your-dockerhub-id>`

## Running a standalone container ##

To test the application prior to deploying it to a cluster, you can launch the container with the following command:

`docker run -d --rm -p 8080:8080 email-parse:latest`

This will set up the container so that it is listening on port 8080 on your local machine. You can then test connectivity to the container with the following command:

`curl -X POST -H "Content-Type: text/plain" --data-binary @./testdata/test_email.msg localhost:8080`

To cleanup the container after you are done, you can run the following command:

`./cleanup_container.sh`

## Deploying to a Kubernetes cluster or Minikube

If you are running this under minikube, you will first need to run the following command in a separate window:

`minikube tunnel`

Note that this command will run in the foreground. Leave it running through the deployment and test. If you do not run this or terminate the process, the loadbalancer will not come up and will show as `<pending>`.

If you are deploying this to a cluster in AWS and do not have the ability to create external loadbalancers, please see the comment in file deployment.yaml.

To deploy the application, run the following:

`deploy.sh <your-dockerhub-id>`

Note that this will create a new file called custom_deployment.yaml. The source is the file deployment.yaml, which contains a placeholder for the docker hub ID. If you need to manually redeploy for whatever reason, please use this file.

You can monitor the progress of the startup with:

`kubectl -n email-parse get pods`

One the pod shows 1/1 replicas ready, run the following command to obtain the IP of the loadbalancer:

`kubectl -n email-parse get services`

If the IP for the service is still showing as `<pending>`, you may have one of the following issues:

* You are deploying to a minikube environment and are not running `minikube tunnel` in another window or the command was terminated or failed.
* You are deploying to a cloud environment where external loadbalancers are blocked. See the comments in deployment.yaml.

You can do a final test of the deployed application by first noting the IP of the loadbalancer and running the following command:

`curl -X POST -H "Content-Type: text/plain" --data-binary @./testdata/test_email.msg <loadbalancer-ip>`
