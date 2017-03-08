#!/bin/bash
echo "Login to the K8S environment"
#az account set --subscription "Microsoft Azure Internal Consumption"
az acs kubernetes get-credentials --resource-group ossdemo-kubernetes --name ossdemo-k8s-REPLACEME

echo "create secret to login to the private registry"
kubectl create secret docker-registry ossdemoRegistryKey --docker-server=REPLACE-REGISTRY-NAME-microsoft.azurecr.io --docker-username=REPLACE-REGISTRY-NAME --docker-password=MbR=REPLACE-REGISTRY-PASSWORD --docker-email=GBBOSS@microsoft.com
