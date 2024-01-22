#!/bin/bash

export dont_hack_me=1

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color
export GREEN_BOLD='\033[1;32m'

# install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube config set driver docker
# start minikube
sudo minikube start
# check the status
sudo minikube status
alias kubectl="sudo minikube kubectl --"
# check the nodes
kubectl get nodes
