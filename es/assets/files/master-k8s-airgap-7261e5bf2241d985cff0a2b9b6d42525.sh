#!/bin/bash
# TODO - usage
# lr-bash.sh NODE
NODE_NAME=master-k8s
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
 
 #https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
 # Ignoring preflight-errors, probably you VM is small, but we are creating the base to be exported ;)
sudo kubeadm init \
  --apiserver-advertise-address=$IP_NODE \
  --pod-network-cidr=10.244.0.0/16 \
  --kubernetes-version=v1.24.3 \
  --cri-socket=unix:///var/run/cri-dockerd.sock \
  --ignore-preflight-errors=Mem > ~/kubeadm.init.log
# IMPORTANT: ~/kubeadm.init.log generated file include the token required to join the worker nodes to the cluster
# https://stackoverflow.com/a/72878730/5078874

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "##### initiate the Flannel network in Control Plane node #####"
kubectl apply -f $HOME/lr-airgap/flannel/kube-flannel.yml
echo '##### initiate the nginx ingress pods #####'
kubectl apply -f $HOME/lr-airgap/nginx/deploy.yaml
