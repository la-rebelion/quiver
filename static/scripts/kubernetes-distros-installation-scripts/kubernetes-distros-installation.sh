#!/bin/bash

export dont_hack_me=1

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export CYAN='\033[0;36m'
export PURPLE='\033[0;35m'
export NC='\033[0m' # No Color
export GREEN_BOLD='\033[1;32m'

export SUBSCRIBE='\e]8;;https://go.rebelion.la/subscribe\e\\subscribe here to get latest\e]8;;\e\\'
export K1S_TERM='\e]8;;https://k1s.sh\e\\K1s Terminal\e]8;;\e\\'

clear -x
echo -e "${GREEN_BOLD}Welcome to Rebelion's Kubernetes Distros Installation Scripts${NC} ✊🏽"
echo "This scripts use multipass to create VMs and install Kubernetes distros."
echo -e "If you don't have multipass installed or don't want to use it, use ssh to\nconnect&execute commands, and scp to copy the file to the VMs\n... but ${RED}you will have to do it manually or customize the scripts${NC}.\n\n"

# check if multipass is installed
if ! command -v multipass &> /dev/null
then
    echo -e "${RED}multipass could not be found${NC}"
    echo "Please install multipass and try again."
    exit
fi

# define a list of options for menu
options=("Create VMs for Lab" "Install K0s Cluster" "Install K3s Cluster" "Install microk8s Cluster" "Install minikube Cluster" "Clean up | Un-install" "Quit" "Subscribe to Rebelion's Newsletter" "Visit K1s Terminal")

# function to print menu
function print_menu() {
  echo "Please select an option:"
  for i in "${!options[@]}"; do
    echo -e "${GREEN_BOLD}$((i+1)))${NC} ${options[$i]}"
  done
  echo -e "\n${YELLOW}Don't forget to visit https://k1s.sh\n${NC}"
  read -p "Enter your choice: " choice
}

# open URL in browser
function open_url() {
    url=$1
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open $url
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open $url
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
        start $url
    else
        echo "Can't open URL on this platform"
    fi
}

function print_quick_message() {
    echo "Quitting..."
    echo -e "\n${YELLOW}Don't forget to visit ${PURPLE}${K1S_TERM} 💻"
    echo -e "\n${YELLOW}Also ${CYAN}${SUBSCRIBE}${YELLOW} scripts and articles${NC} 📰\n"
}

print_menu
while true; do
  case $choice in
    1)
      # Create VMs for Lab
      time ./_create-vms.sh
      ;;
    2)
      # Install K0s Cluster
      echo "I got you, I am going to install K0s on the VMs..."
      #scp ./$env_file $ssh_user@$host:~/.env
      # ssh $ssh_user@$host 'bash -s' < ./_install-edb.sh >> logs.txt
      #ssh $ssh_user@$host 'bash -s' < ./_k0s-master.sh
      # install master
      echo "Installing master..."
      current_node=k0s1-rebelion
      # I didn't make it work with exec bash -s, so I am using transfer instead
      # loop through the VMs to transfer the script and execute it
      multipass transfer ./_k0s-master.sh $current_node:/home/ubuntu/_k0s-master.sh
      multipass exec $current_node -- chmod +x ./_k0s-master.sh
      time multipass exec $current_node -- ./_k0s-master.sh > $current_node.log
      # read the token file from the master log
      export token=$(tail -n 1 ${current_node}.log)
      
      # install workers
      truncated_token=$(echo $token | cut -c1-8)
      echo "Installing workers with token: $truncated_token..."
      for i in {2..3}; do multipass transfer ./_k0s-worker.sh k0s${i}-rebelion:/home/ubuntu/_k0s-worker.sh; multipass exec k0s${i}-rebelion -- chmod +x ./_k0s-worker.sh; multipass exec k0s${i}-rebelion -- ./_k0s-worker.sh $token > k0s${i}-rebelion.log; done
      echo -e "${GREEN_BOLD}Worker nodes are ready, enjoy your K0s cluster!${NC} 0️⃣\n\n"
      ;;
    3)
      # Install K3s Cluster
      echo "Of course, I am going to install K3s on the VMs..."
      echo "Installing master..."
      current_node=k3s1-rebelion
      multipass transfer ./_k3s-master.sh $current_node:/home/ubuntu/_k3s-master.sh
      multipass exec $current_node -- chmod +x ./_k3s-master.sh
      time multipass exec $current_node -- ./_k3s-master.sh > $current_node.log
      echo "Master node is ready"
      # read the token file from the master log
      #export token=$(cat ${current_node}.log | grep "node-token" | awk '{print $NF}')
      export token=$(tail -n 1 ${current_node}.log)
      truncated_token=$(echo $token | cut -c1-8)
      # install workers
      echo "Installing workers with token: $truncated_token..."
      # loop in nodes 2 and 3 to install workers
      # didn't make it work with exec in single command, so I am using transfer + exec instead
      #for i in {2..3}; do echo "Installing worker ${i-1}..."; time multipass exec k3s${i}-rebelion -- curl -sfL https://get.k3s.io | K3S_URL=https://k3s1-rebelion:6443 K3S_TOKEN=$token sudo sh - > k3s${i}-rebelion.log; done
      for i in {2..3}; do echo "Installing worker ${i-1}..."; multipass transfer ./_k3s-worker.sh k3s${i}-rebelion:/home/ubuntu/_k3s-worker.sh; multipass exec k3s${i}-rebelion -- chmod +x ./_k3s-worker.sh; time multipass exec k3s${i}-rebelion -- ./_k3s-worker.sh $token > k3s${i}-rebelion.log; done
      echo -e "${GREEN_BOLD}Worker nodes are ready, enjoy your K3s cluster!${NC} 3️⃣\n\n"
      #kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml get nodes
      ;;
    4)
      # Install microk8s Cluster
      echo "I got you bro, I am going to install microk8s on the VMs..."
      echo "Installing master..."
      current_node=microk8s1-rebelion
      multipass transfer ./_microk8s-server.sh $current_node:/home/ubuntu/_microk8s-server.sh
      multipass exec $current_node -- chmod +x ./_microk8s-server.sh
      time multipass exec $current_node -- ./_microk8s-server.sh > $current_node.log
      # read the join command from the master log at the end of the file
      #export join_command=$(tail -n 1 microk8s1-rebelion.log)
      echo "Master node is ready"
      # install workers
      echo "Installing workers..."
      # loop in nodes 2 and 3 to install workers
      for i in {2..3}
      do
        export join_command=$(multipass exec $current_node -- sudo microk8s add-node | tail -n 1)
        echo "Installing worker ${i-1}..."
        multipass transfer ./_microk8s-worker.sh microk8s${i}-rebelion:/home/ubuntu/_microk8s-worker.sh
        multipass exec microk8s${i}-rebelion -- chmod +x ./_microk8s-worker.sh
        time multipass exec microk8s${i}-rebelion -- ./_microk8s-worker.sh $join_command > microk8s${i}-rebelion.log
      done
      multipass exec $current_node -- sudo microk8s kubectl get nodes
      echo -e "${GREEN_BOLD}Worker nodes are ready, enjoy your microk8s cluster!${NC} 8️⃣\n\n"
      ;;
    5)
      # Install minikube Cluster
      #echo "Sure, I am going to install minikube on THE VM..."
      #echo "Installing minikube..."
      #multipass transfer ./_minikube-master.sh minikube-rebelion:/home/ubuntu/_minikube.sh
      #multipass exec minikube-rebelion -- chmod +x ./_minikube.sh
      #time multipass exec minikube-rebelion -- ./_minikube.sh > minikube-rebelion.log
      # ****** Above is not needed, minikube is already installed in the VM thanks to multipass launch minikube!
      echo -e "${GREEN_BOLD}minikube is ready thanks to multipass, enjoy!${NC} Ⓜ️"
      echo -e "${YELLOW}The only caveat is that minikube's VM requires much more resources than the other VMs.${NC}"
      echo -e "${RED}CPU: 2, Memory: 4G, Disk: 40G${NC}\n"
      echo "One more thing, remember that minikube doesn't support multiple VMs,"
      echo "so we are going to launch only one VM for minikube."
      echo "If you want to use cluster with multiple VMs,"
      echo "you can use kubeadm or any of the other distros."
      echo "----------------------------------------"
      echo -e "${GREEN}'Adding 2 nodes' to minikube server...${NC}"
      time multipass exec minikube-rebelion -- minikube start --nodes 3 -p la-rebelion-cluster
      #time multipass exec minikube-rebelion -- minikube node add
      #time multipass exec minikube-rebelion -- minikube node add
      echo -e "${GREEN_BOLD}2 nodes added to minikube server!${NC}\n\n"
      multipass exec minikube-rebelion -- kubectl get nodes
      ;;
    6)
      # Clean up | Un-install
      echo "At your service, I am going to clean up the VMs. Please confirm..."
      read -p "Are you sure you want to clean up the VMs? (y/n) " -n 1 -r
      echo ""
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        echo "Cleaning up the VMs..."
        time multipass delete k0s1-rebelion k0s2-rebelion k0s3-rebelion k3s1-rebelion k3s2-rebelion k3s3-rebelion microk8s1-rebelion microk8s2-rebelion microk8s3-rebelion minikube-rebelion
        echo -e "${GREEN_BOLD}VMs cleaned up!${NC} 🧹🧼🧽"
      fi      
      ;;
    7)
      # QUIT
      print_quick_message
      break
      ;;
    8)
      # Subscribe to Rebelion's Newsletter
      echo -e "${SUBSCRIBE}"
      open_url https://go.rebelion.la/subscribe
      ;;
    9)
      # Visit K1s Terminal
      echo -e "${K1S_TERM}"
      open_url https://k1s.sh
      ;;
    q)
      # QUIT
      print_quick_message
      break
      ;;
    *)
      echo "Invalid selection"
      ;;
  esac
  print_menu
  clear -x
done
