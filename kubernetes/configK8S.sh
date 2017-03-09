#!/bin/bash
echo "Login to the K8S environment"
#az account set --subscription "Microsoft Azure Internal Consumption"
az acs kubernetes get-credentials --resource-group ossdemo-kubernetes --name ossdemo-k8s-UNIQUE-SERVER-PREFIX

echo "create secret to login to the private registry"
kubectl create secret docker-registry ossdemoRegistryKey --docker-server=REGISTRY-SERVER-NAME --docker-username=REGISTRY-USER-NAME --docker-password=MbR=REGISTRY-PASSWORD --docker-email=GBBOSS@microsoft.com
