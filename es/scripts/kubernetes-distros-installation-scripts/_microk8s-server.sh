#!/bin/bash

export dont_hack_me=1

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color
export GREEN_BOLD='\033[1;32m'

#install snapd
sudo apt update
sudo apt install snapd
#install microk8s
time sudo snap install microk8s --classic
# wait for microk8s to start
sudo microk8s status --wait-ready
# iptables (optional) permit traffic between the VM and host, 
# just in case you want to access the cluster from the host
sudo iptables -P FORWARD ACCEPT
# NOTE: microk8s add-node changes the token every time a new node is added! ⚠️

# one step further, getting the token to join the cluster
# Run the command and store the output       ---- Remove from this script, didn't work, microk8s add-node changes the token every time a new node is added
#output=$(sudo microk8s add-node) 
# Extract the second line
#join_command=$(echo "$output" | sed -n '2p')
#echo sudo $join_command --worker