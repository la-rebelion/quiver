#!/bin/bash

export dont_hack_me=1

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color
export GREEN_BOLD='\033[1;32m'

# print each command that the script executes
set -x

curl -sfL https://get.k3s.io | sudo sh - 
# Check for Ready node, takes ~30 seconds, we won't wait for it, just check if it's there 
sudo k3s kubectl get nodes 
# Check for Ready pod, takes ~60 seconds, we won't wait for it, just check for logs
sudo k3s kubectl get pod --all-namespaces
# get the token to join workers to the cluster
sudo cat /var/lib/rancher/k3s/server/node-token