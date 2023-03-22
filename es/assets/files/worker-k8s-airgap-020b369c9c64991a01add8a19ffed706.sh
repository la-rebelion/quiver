#!/bin/bash
# TODO - usage
# lr-bash.sh NODE
NODE_NAME=worker1-k8s
MASTER_NODE=172.19.45.233
TOKEN_K8S=nvh0qt.bpzhigoaqgre3cbg
CERT_K8S=sha256:0485f36c3d2e93156626a9081825f5a1ac0d8d92d9e5eadcb3aefb6885048a6a
# TODO - token and cert (for workers)
#sudo apt-get update
#sudo apt-get -y install \
#  apt-transport-https \
#  ca-certificates \
#  curl \
#  gnupg \
#  lsb-release \
#  sshfs

echo "##### Installing Docker #####"
cd ~/lr-airgap/docker-ce
sudo dpkg -i *
# install Docker file drivers:
# Already installed on Ubuntu: lvm2

# enable and start docker service:
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo docker version

## Install Kubernetes - Kubeadm (offline machine)
echo "##### Installing k8s #####"
cd ~/lr-airgap/kube
sudo dpkg -i *
sudo apt-mark hold kubelet kubeadm kubectl

echo '##### list of images required for setting up your Kubernetes cluster #####'
kubeadm config images list

echo "##### loading required k8s images #####"
cd ~/lr-airgap/k8s-images
# unpack and load images
for x in *.tar; do sudo docker load < $x && echo "loaded from file $x"; done;

### Provisioning Network
echo "##### loading network images - flannel #####"
cd ~/lr-airgap/flannel
# unpack and load images
for x in *.tar; do sudo docker load < $x && echo "loaded from file $x"; done;

echo "##### loading ingress/nginx #####"
cd ~/lr-airgap/nginx
for x in *.tar; do sudo docker load < $x && echo "loaded from file $x"; done;

echo "##### Deploying Kubernetes cluster - $NODE_NAME node #####"
sudo hostnamectl set-hostname "$NODE_NAME"
# disable swap for the current session or comment out swap partitions or swap file from fstab file
swapoff -a
# Ensure that SELinux is in permissive mode
setenforce 0
#https://stackoverflow.com/a/18836896/5078874
# if /etc/selinux/config file exists:
#sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
# assuming the file does NOT exist
sudo touch /etc/selinux/config
sudo bash -c 'echo "SELINUX=permissive" >  /etc/selinux/config'
sudo bash -c 'cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF'
sudo sysctl --system

# In case you don’t have your own dns server then update /etc/hosts file on master and worker nodes
IP_NODE=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
sudo bash -c "cat <<EOF >> /etc/hosts
$(ip addr show eth0 | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1) $(hostname)
EOF"

# More workers/masters here

 # enable kubelet service
sudo systemctl enable kubelet.service
kubectl version --output=yaml

sudo kubeadm join $MASTER_NODE:6443 --token $TOKEN_K8S \
  --cri-socket=unix:///var/run/cri-dockerd.sock \
  --discovery-token-ca-cert-hash $CERT_K8S
# IMPORTANT: ~/kubeadm.init.log is stored in master node, includes the token required to join the worker nodes to the cluster

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#echo "##### initiate the Flannel network in Control Plane node #####"
#kubectl apply -f $HOME/lr-airgap/flannel/kube-flannel.yml
#echo '##### initiate the nginx ingress pods #####'
#kubectl apply -f $HOME/lr-airgap/nginx/deploy.yaml

echo ""
echo ""
echo "Your node $NODE_NAME $IP_NODE is ready for the rumble"
echo "$(date) : forza Rebels!"
echo "TO DO Don't forget to edit /etc/hosts"
echo "=========DONE========="

## In case your multipass master node changes IP, you will need to change advertise IP
## Two options:
## replacing the IPs in files (etcd.yaml; kube-apiserver.yaml) located at: cd /etc/kubernetes/manifests/
### sudo grep "$MASTER_NODE" /etc/kubernetes/manifests/*
## reset the master and run init again
### You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
### kubeadm reset --cri-socket=unix:///var/run/cri-dockerd.sock
### sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#https://stackoverflow.com/a/67628482/5078874

# Verify nodes and components:
#kubectl get nodes
#kubectl get componentstatuses

#CURRENT_IP=172.18.85.251
#MASTER_NODE=172.19.45.233
#sudo sed 's/'$CURRENT_IP'$/'$MASTER_NODE'/g' etcd.yaml
