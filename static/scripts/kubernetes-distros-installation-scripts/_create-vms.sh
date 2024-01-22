#!/bin/bash

# Get the start time
start_time=$(date +%s)

# The default username and password are both "ubuntu"

# Create the VMs
for i in {1..3}; do multipass launch --name k0s${i}-rebelion -c 1 -m 1G -d 5G; multipass launch --name k3s${i}-rebelion -c 1 -m 1G -d 5G; multipass launch --name microk8s${i}-rebelion -c 1 -m 1G -d 5G; echo "${i} loop for VMs done. 🔁"; done
echo "VMs created."
echo "minikube doesn't support multiple VMs, so we are going to launch only one VM for minikube."
# launch failed: Requested Number of CPUs is less than Blueprint minimum of 2
# launch failed: Requested Memory size is less than Blueprint minimum of 4G
# launch failed: Requested Disk space is less than Blueprint minimum of 40G
multipass launch --name minikube-rebelion -c 2 -m 4G -d 40G minikube

# Get the end time
end_time=$(date +%s)

# Calculate the time difference and print it
echo "Time elapsed to create VMs: $(($end_time - $start_time)) seconds"

# additional chore commands
# wait for VMs to be ready   -- NOT needed, multipass launch does this
#echo "Waiting for VMs to be ready..."
#sleep 30
# multipass list to get IP addresses
multipass list | awk 'NR>1 {print $3 " " $1}' > multipass_hosts.txt
echo "multipass_hosts.txt created, adding to local /etc/hosts"
# The tee command is used instead of the >> operator because tee can be used with sudo, while the >> operator cannot.
if [[ "$OSTYPE" == "msys" ]]; then
    # Windows/git bash doesn't have sudo
    cat multipass_hosts.txt | tee -a /etc/hosts
    echo "Git Bash"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cat multipass_hosts.txt | sudo tee -a /etc/hosts
    echo "Linux"
else
    echo "Unknown - $OSTYPE, addapt the script as needed."
fi
# now adding multipass_hosts.txt to remote /etc/hosts in the VM instances
echo "Adding multipass_hosts.txt to remote /etc/hosts in the VM instances"

for i in {1..3}; do multipass transfer multipass_hosts.txt k0s${i}-rebelion:/home/ubuntu/multipass_hosts.txt; multipass transfer multipass_hosts.txt k3s${i}-rebelion:/home/ubuntu/multipass_hosts.txt; multipass transfer multipass_hosts.txt microk8s${i}-rebelion:/home/ubuntu/multipass_hosts.txt; done

# Connect to the instances and add the hosts to /etc/hosts
for i in {1..3}; do multipass exec k0s${i}-rebelion -- bash -c 'cat multipass_hosts.txt | sudo tee -a /etc/hosts'; multipass exec k3s${i}-rebelion -- bash -c 'cat multipass_hosts.txt | sudo tee -a /etc/hosts'; multipass exec microk8s${i}-rebelion -- bash -c 'cat multipass_hosts.txt | sudo tee -a /etc/hosts'; done

echo "I am done with my chores. 🧹🧼🧽"
echo "You can now run the installation scripts for the distros of your choice."
echo "Have fun! 🤓"

# Get the end time
end_time=$(date +%s)

# Calculate the time difference and print it
echo "Time elapsed to create + chores on VMs: $(($end_time - $start_time)) seconds"
