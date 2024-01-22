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
  echo -e "${RED}No token argument passed${NC}"
  echo "Please pass the token argument and try again."
  exit 1
fi

# assign the token argument to a variable
token=$1

# print each command that the script executes
#set -x

# Get the start time
start_time=$(date +%s)

# as easy as that, not really, but it's a start
curl -sfL https://get.k3s.io | K3S_TOKEN=$token K3S_URL=https://k3s1-rebelion:6443 INSTALL_K3S_EXEC="agent" sudo sh -
# Flags used:
#   agent - install the agent, not the server
#   token - the token used to join the cluster
#   server - the server url to join the cluster
#   disable-apiserver-lb - disable the load balancer for the apiserver, we don't need it for 1 master (not HA)
# workaround for agent and LoadBalancer, this was painful, no k3s-agent service is created!
# so, we need to run the agent manually and disable the apiserver-lb
sudo systemctl stop k3s
# start the agent in the background
sudo k3s agent --server https://k3s1-rebelion:6443 -t $token --disable-apiserver-lb > /dev/null 2>&1 &

# Get the end time
end_time=$(date +%s)
# Calculate the time difference and print it
echo "Time elapsed to create worker: $(($end_time - $start_time)) seconds"
exit 0
