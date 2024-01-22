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
  exit
fi

# assign the token argument to a variable
token=$1

# print each command that the script executes
set -x

# Get the start time
start_time=$(date +%s)

# download the K0s binary
curl -sSLf https://get.k0s.sh | sudo sh
# install K0s
echo $token > token-file
sudo k0s install worker --token-file token-file
sudo systemctl daemon-reload
sudo k0s start
# check the status
sudo k0s status

# Get the end time
end_time=$(date +%s)
# Calculate the time difference and print it
echo "Time elapsed to create worker: $(($end_time - $start_time)) seconds"
