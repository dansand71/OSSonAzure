#!/bin/bash
echo "Login to the K8S environment"
#az account set --subscription "Microsoft Azure Internal Consumption"
az acs kubernetes get-credentials \
        --resource-group ossdemo-kubernetes \
        --name ossdemo-k8s-VALUEOF-UNIQUE-SERVER-PREFIX

echo "create secret to login to the private registry"
kubectl create secret docker-registry ossdemoRegistryKey \
        --docker-server=VALUEOF-REGISTRY-SERVER-NAME \
        --docker-username=VALUEOF-REGISTRY-USER-NAME \
        --docker-password=VALUEOF-REGISTRY-PASSWORD \
        --docker-email=GBBOSS@microsoft.com
