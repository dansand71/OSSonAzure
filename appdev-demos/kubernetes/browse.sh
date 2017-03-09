#!/bin/bash
echo "Browse the K8S Cluster"
#az account set --subscription "Microsoft Azure Internal Consumption"
az acs kubernetes browse \
    -n ossdemo-k8s-cluster-VALUEOF-UNIQUE-SERVER-PREFIX \
    -g ossdemo-kubernetes
