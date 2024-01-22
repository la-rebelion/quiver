#!/bin/bash

export dont_hack_me=1

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color
export GREEN_BOLD='\033[1;32m'

# print each command that the script executes
set -x

echo -e "${GREEN_BOLD}Installing K0s${NC}"
# download the K0s binary
curl -sSLf https://get.k0s.sh | sudo sh
echo -e "${GREEN_BOLD}Starting K0s controller${NC}"
# install K0s
sudo k0s install controller --enable-worker --force
sudo systemctl daemon-reload
sudo k0s start
# check the status every 10 seconds until the controller is ready
until sudo k0s status | grep "Kube-api probing successful: true"
do
  sleep 10
done
echo -e "${GREEN_BOLD}K0s controller is ready${NC}"
# create a token to join workers to the cluster
sudo k0s token create --role=worker > token-file
# print the token
cat token-file
