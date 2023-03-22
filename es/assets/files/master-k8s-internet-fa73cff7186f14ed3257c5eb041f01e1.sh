#!/bin/bash
## Add Docker’s official GPG key:
sudo mkdir -p /etc/apt/keyrings
curl -fsSL, https://download.docker.com/linux/ubuntu/gpg  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 # set up the repository:
'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
sudo apt-get -y update
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
mkdir /run/docker
[ wget, "https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.3/cri-dockerd_0.2.3.3-0.ubuntu-jammy_amd64.deb", -O, /run/docker/cri-dockerd_0.2.3.3-0.ubuntu-jammy_amd64.deb]
sudo dpkg -i /rund/docker/cri-dockerd_0.2.3.3-0.ubuntu-jammy_amd64.deb
 
 ## install Kubernetes (online machine/Docker host)
 # install the Kubernetes repository:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get -y update
sudo apt-get -y install kubelet=1.24.* kubeadm=1.24.* kubectl=1.24.* cri-tools=1.24.* conntrack ebtables kubernetes-cni socat selinux-utils
sudo apt-mark hold kubelet kubeadm kubectl
 
 
 # pulling images from k8s registry, follow this steps:
mkdir -p /etc/docker/certs.d/registry.k8s.io
 # Download the certificates https://stackoverflow.com/a/70011298/5078874
 # and move it to /etc/docker/certs.d/registry.k8s.io
 # https://velaninfo.com/rs/techtips/docker-certificate-authority/
'openssl s_client -showcerts -connect registry.k8s.io:443 </dev/null 2>/dev/null | sed -n "/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p"  > /etc/docker/certs.d/registry.k8s.io/registry-k8s.crt'
 # Create file /etc/docker/daemon.json and add insecure-registries
 # OR add insecure registry in the docker service arguments instead
 
 # enable and start docker service:
sudo systemctl enable docker
 # k8s.grc.io uses self-signed cert https://docs.docker.com/registry/insecure/
sudo systemctl start docker --insecure-registry k8s.gcr.io:443
 # verify docker:
 # - sudo systemctl status docker
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo docker version
 
 # pull k8s images
sudo docker pull k8s.gcr.io/kube-apiserver:v1.24.3
sudo docker pull k8s.gcr.io/kube-controller-manager:v1.24.3
sudo docker pull k8s.gcr.io/kube-scheduler:v1.24.3
sudo docker pull k8s.gcr.io/kube-proxy:v1.24.3
sudo docker pull k8s.gcr.io/pause:3.7
sudo docker pull k8s.gcr.io/etcd:3.5.3-0
sudo docker pull k8s.gcr.io/coredns/coredns:v1.8.6
 
 ##### Download networking files (online machine)
mkdir /run/k8s
[ wget, "https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml", -O, /run/k8s/kube-flannel.yml ]
 # download and save the required image (from previous command)
sudo docker pull docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0
sudo docker pull docker.io/rancher/mirrored-flannelcni-flannel:v0.19.0
 ##### Download NGINX images (online machine)
 #https://github.com/kubernetes/ingress-nginx
 #https://kubernetes.io/docs/concepts/services-networking/ingress/
 
[ wget, "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/1.24/deploy.yaml", -O, /run/k8s/deploy.yaml ]
 
 # download NGINX images:
sudo docker pull registry.k8s.io/ingress-nginx/controller:v1.3.0
sudo docker pull registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1
 
 ## Deploying Kubernetes cluster (offline machine)
 
sudo hostnamectl set-hostname 'master-k8s'
 # disable swap for the current session or comment out swap partitions or swap file from fstab file
swapoff -a
 # Ensure that SELinux is in permissive mode
setenforce 0
 #https://stackoverflow.com/a/18836896/5078874
 #sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
 # assuming the file does not exist
sudo touch /etc/selinux/config
sudo bash -c 'echo "SELINUX=permissive" >  /etc/selinux/config
sudo bash -c 'echo -e "cat <<EOF >  /etc/sysctl.d/k8s.conf\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nEOF\n"
sudo sysctl --system
 
 # enable kubelet service
sudo systemctl enable kubelet.service
kubectl version
 
 #https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
 #kubeadm init --config kubeadm-config.yaml --pod-network-cidr=10.244.0.0/16 --kubernetes-version=v1.24.3 > ~/kubeadm.init.log
sudo kubeadm init --apiserver-advertise-address=172.24.240.24 --pod-network-cidr=10.244.0.0/16 --kubernetes-version=v1.24.3 --cri-socket=unix:///var/run/cri-dockerd.sock  --ignore-preflight-errors=Mem > ~/kubeadm.init.log
 # IMPORTANT: ~/kubeadm.init.log generated file include the token required to join the worker nodes to the cluster
 # https://stackoverflow.com/a/72878730/5078874
 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
  # initiate the Flannel network in Control Plane node:
kubectl apply -f /run/k8s/kube-flannel.yml
  # initiate the nginx ingress pods
kubectl apply -f /run/k8s/deploy.yaml
