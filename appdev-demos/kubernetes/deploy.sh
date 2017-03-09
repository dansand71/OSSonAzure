#!/bin/bash
echo "Initial deployment & expose the service"
#az account set --subscription "Microsoft Azure Internal Consumption"
kubectl create -f /source/OSSonAzure/kubernetes/aspnet-core-linux-deploy.yml

echo "Initial deployment & expose the service"
kubectl expose deployments aspnet-core-linux-deployment \
        --port=80 --target-port=5000 \
        --type=LoadBalancer \
        --name=aspnet-core-linux
