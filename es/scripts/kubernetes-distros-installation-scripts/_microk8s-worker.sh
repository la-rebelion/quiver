#!/bin/bash

export dont_hack_me=1

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color
export GREEN_BOLD='\033[1;32m'

# check if the token argument was passed
if [ -z "$1" ]
then
  echo -e "${RED}No join argument passed${NC}"
  echo "Please pass the join argument and try again."
  exit
fi

# assign the join command argument to a variable
join_command=$1
#install snapd
sudo apt update
sudo apt install snapd
#install microk8s
time sudo snap install microk8s --classic
# wait for microk8s to start
sudo microk8s status --wait-ready
#join the cluster
echo "Joining the cluster with $join_command"
sudo $join_command --worker

