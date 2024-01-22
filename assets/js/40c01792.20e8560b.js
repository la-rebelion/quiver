"use strict";(self.webpackChunkquiver=self.webpackChunkquiver||[]).push([[244],{2407:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>k,contentTitle:()=>d,default:()=>b,frontMatter:()=>c,metadata:()=>u,toc:()=>p});var s=t(7462),r=(t(7294),t(3905)),o=t(2004),a=t.n(o),i=t(4866),l=t(5162);const c={sidebar_label:"Install Kubernetes in Ubuntu 22.04",sidebar_position:1,title:"Installation of Kubernetes and Docker in offline Ubuntu 22.04",description:"If you don't have connectivity to Internet, install Kubernetes following these steps",keywords:["kubernetes","installation","docker"]},d="Steps to install Kubernetes in Ubuntu 22.04",u={unversionedId:"kubernetes/installation/k8s-docker-install-offline",id:"kubernetes/installation/k8s-docker-install-offline",title:"Installation of Kubernetes and Docker in offline Ubuntu 22.04",description:"If you don't have connectivity to Internet, install Kubernetes following these steps",source:"@site/docs/kubernetes/installation/k8s-docker-install-offline.mdx",sourceDirName:"kubernetes/installation",slug:"/kubernetes/installation/k8s-docker-install-offline",permalink:"/kubernetes/installation/k8s-docker-install-offline",draft:!1,tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_label:"Install Kubernetes in Ubuntu 22.04",sidebar_position:1,title:"Installation of Kubernetes and Docker in offline Ubuntu 22.04",description:"If you don't have connectivity to Internet, install Kubernetes following these steps",keywords:["kubernetes","installation","docker"]},sidebar:"tutorialSidebar",previous:{title:"Kubernetes-Installation",permalink:"/category/kubernetes-installation"},next:{title:"Kubernetes Distros",permalink:"/kubernetes/installation/kubernetes-distros-installation"}},k={},p=[{value:"Bonus",id:"bonus",level:3}],m={toc:p},g="wrapper";function b(e){let{components:n,...o}=e;return(0,r.kt)(g,(0,s.Z)({},m,o,{components:n,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"steps-to-install-kubernetes-in-ubuntu-2204"},"Steps to install Kubernetes in Ubuntu 22.04"),(0,r.kt)("p",null,"All the commands, step by step on how to install Docker and Kubernetes in an offline environment. We will need ",(0,r.kt)("inlineCode",{parentName:"p"},"multipass")," installed."),(0,r.kt)(a(),{playing:!0,controls:!0,url:"https://youtu.be/f71Z6SVzhVg",mdxType:"ReactPlayer"}),(0,r.kt)("hr",null),(0,r.kt)("p",null,"Click on each of the tabs to complete the whole installation. I have tried to separated each tab depending on the different goals."),(0,r.kt)("p",null,"Follow the video above for specifics."),(0,r.kt)(i.Z,{mdxType:"Tabs"},(0,r.kt)(l.Z,{value:"bash",label:"1 \ud83d\udcd0 Setup",default:!0,mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-bash"},"# 0 what options do we have?\nmultipass find\n# my 'online VM' Ubuntu 22.04\nmultipass launch --name pc-online --cpus 2 --mem 2048M --disk 5G jammy\n# 1 Create 2 nodes 'flavors': master and worker\nmultipass launch --name master-k8s --cpus 2 --mem 3G --disk 6G jammy\nmultipass launch --name worker1-k8s --cpus 2 --mem 3G --disk 6G jammy\n#multipass launch --name docker-registry --cpus 2 --mem 2048M --disk 10G\n\n# 2 Check if we have the VMs running and setup your local DNS (to connect easily - I tend to forget IPs :p)\nmultipass list\nprimary                 172.24.223.205\nmaster-k8s              172.24.216.0  \npc-online               172.24.213.201\n\"192.x.x.x   master-k8s\" >> C:\\Windows\\System32\\drivers\\etc\\hosts\n# More than one line\n@\"192.x.x.x   master-k8s\n192.x.x.x   worker1-k8s\n\"@ | out-file C:\\Windows\\System32\\drivers\\etc\\hosts -enc ASCII -append\ncat C:\\Windows\\System32\\drivers\\etc\\hosts\n\n# previous command is similar to this in Linux:\ncat <<EOF > /etc/hosts\nmaster-k8s  172.24.216.54\nworker1-k8s 172.24.222.216\nEOF\n"))),(0,r.kt)(l.Z,{value:"download-docker",label:"2 \u2b07\ufe0f Docker",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},'# multipass configuration - mount directory in PC host to "simulate" scp/transfer files - we will see this later\n\n## 3 Download Docker (online machine/Docker host)\nmultipass shell pc-online\n# Update the apt package index\nsudo apt-get update\nsudo apt-get -y install \\\n  apt-transport-https \\\n  ca-certificates \\\n  curl \\\n  gnupg \\\n  lsb-release \\\n  sshfs\n\nmkdir -p ~/lr-airgap/docker-ce\ncd ~/lr-airgap/docker-ce\n# Please install the \'multipass-sshfs\' snap manually inside the instance\n# GOTO PowerShell window\nPS: multipass mount . pc-online:~/lr-airgap\n\n# Add Docker\u2019s official GPG key:\nsudo mkdir -p /etc/apt/keyrings\ncurl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg\n\n# set up the repository:\necho \\\n"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \\\n$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\n\nsudo apt-get update\n# if a GPG error when\nsudo chmod a+r /etc/apt/keyrings/docker.gpg\n\n# download required files\n#https://ostechnix.com/download-packages-dependencies-locally-ubuntu/\nsudo apt-get download docker-ce docker-ce-cli containerd.io docker-compose-plugin\n# Ignore Warning like: "W: ... _apt ..."\n\n#Docker Engine does not implement the CRI, it was removed from the kubelet in version 1.24.\n#https://github.com/Mirantis/cri-dockerd/releases\nwget https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.3/cri-dockerd_0.2.3.3-0.ubuntu-jammy_amd64.deb\n'))),(0,r.kt)(l.Z,{value:"download-k8s",label:"3 \u2b07\ufe0f K8s",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},'## 4 Download Kubernetes (online machine/Docker host)\n\n# install the Kubernetes repository:\nsudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg\necho "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list\nsudo apt-get update\n\nmkdir -p ~/lr-airgap/kube && cd $_\nsudo apt-get download kubelet=1.24.* kubeadm=1.24.* kubectl=1.24.* cri-tools=1.24.* conntrack ebtables kubernetes-cni socat selinux-utils\n'))),(0,r.kt)(l.Z,{value:"copy-and-install",label:"4 \ud83d\udc0b Docker",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},"## 5 Copy the Docker files from the online machine to the offline machine\ncd\ntar -czvf lr-d4r-k8s.tar.gz lr-airgap\n# Connect to your offline machine\nmultipass shell master-k8s\n#ssh ubuntu@master-k8s\nmkdir ~/lr-airgap\n# In your online-pc\n#scp lr-d4r-k8s.tar.gz ubuntu@master-k8s:~/lr-airgap\ntar -xzvf lr-d4r-k8s.tar.gz -C /\n\n## 6 Install Docker (offline machine)\n# Install yum utilities (offline machine)\ncd ~/lr-airgap/docker-ce\nsudo dpkg -i *\n# install Docker file drivers:\n# Already installed on Ubuntu: lvm2\n\n# enable and start docker service:\nsudo systemctl enable docker\nsudo systemctl start docker\n# verify docker:\nsudo systemctl status docker\nsudo systemctl daemon-reload\nsudo systemctl enable cri-docker.service\nsudo systemctl enable --now cri-docker.socket\nsudo docker version\n"))),(0,r.kt)(l.Z,{value:"install-k8s",label:"5 \u2693 Kubernetes",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},'## 7 Install Kubernetes - Kubeadm (offline machine)\ncd ~/lr-airgap/kube\nsudo dpkg -i *\nsudo apt-mark hold kubelet kubeadm kubectl\n\n# run kubeadm, which returns a list of required images:\nkubeadm config images list\n\n# A list of required images is displayed, probably with an error, due to the lack of connectivity to Internet:\n\n### 7.1 Bootstrapping the Kubernetes Control Plane\n\n# In your Multipass VM ("online PC"), pull and save required Kubernetes images\n\n#### Download required Kubernetes Images\nmkdir k8s-images\ncd k8s-images\n# pull the images\nsudo docker pull k8s.gcr.io/kube-apiserver:v1.24.3\nsudo docker pull k8s.gcr.io/kube-controller-manager:v1.24.3\nsudo docker pull k8s.gcr.io/kube-scheduler:v1.24.3\nsudo docker pull k8s.gcr.io/kube-proxy:v1.24.3\nsudo docker pull k8s.gcr.io/pause:3.7\nsudo docker pull k8s.gcr.io/etcd:3.5.3-0\nsudo docker pull k8s.gcr.io/coredns/coredns:v1.8.6\n# save images as TAR archives\nsudo docker save k8s.gcr.io/kube-apiserver:v1.24.3 > kube-apiserver_v1.24.3.tar\nsudo docker save k8s.gcr.io/kube-controller-manager:v1.24.3 > kube-controller-manager_v1.24.3.tar\nsudo docker save k8s.gcr.io/kube-scheduler:v1.24.3 > kube-scheduler_v1.24.3.tar\nsudo docker save k8s.gcr.io/kube-proxy:v1.24.3 > kube-proxy_v1.24.3.tar\nsudo docker save k8s.gcr.io/pause:3.7 > pause_3.7.tar\nsudo docker save k8s.gcr.io/etcd:3.5.3-0 > etcd_3.5.3-0.tar\nsudo docker save k8s.gcr.io/coredns/coredns:v1.8.6  > coredns_1.8.6.tar\n# Package all TAR files\ntar -czvf k8s-images.tar.gz \n# copy to offline server\n#scp k8s-images.tar.gz ubuntu@master-k8s:~/lr-airgap\n\n#### Load Kubernetes Images (offline machine)\n# extract images\nmkdir -p ~/lr-airgap/k8s-images\ncd ~/lr-airgap/\ntar -xzvf k8s-images.tar.gz -C ~/lr-airgap/k8s-images\n# unpack and load images\nfor x in *.tar; do sudo docker load < $x && echo "loaded from file $x"; done;\n'))),(0,r.kt)(l.Z,{value:"provision-network",label:"6 \ud83d\udd78\ufe0f Network",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},"### 8 Provisioning Network\n\n# We chose to use Flannel as our networking option. https://kubernetes.io/docs/concepts/cluster-administration/networking/#flannel\n\n# Flannel is a virtual network that gives a subnet to each host for use with container runtimes.\n# Don't you like Flannel? Check other options [here](https://kubernetes.io/docs/concepts/cluster-administration/networking/).\n\n##### Download networking files (online machine)\n\nwget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml\n# find the flannel image version\ngrep image kube-flannel.yml\n# download and save the required image (from previous command)\nsudo docker pull docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0\nsudo docker pull docker.io/rancher/mirrored-flannelcni-flannel:v0.19.0\nsudo docker save docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.1.0 > flannel-cni-plugin-v1.1.0.tar\nsudo docker save docker.io/rancher/mirrored-flannelcni-flannel:v0.19.0 > flannel-v0.19.0.tar\n# zip the files\ntar -czvf flannel_v0.19.0.tar.gz flannel_v0.19.0.tar kube-flannel.yml\n#gzip -v flannel_v0.19.0.tar\n# copy to offline server\n#scp flannel_v0.19.0.tar.gz root@master-k8s:~/lr-airgap\n\n##### Install Kubernetes networking files (offline machine)\n\ncd ~/lr-airgap/\n# unpack the networking image:\ntar -xzvf flannel_v0.19.0.tar.gz\n#gzip -d flannel_v0.19.0.tar.gz\nsudo docker load < flannel-cni-plugin-v1.1.0.tar\nsudo docker load < flannel-v0.19.0.tar\n"))),(0,r.kt)(l.Z,{value:"download-load-ingress",label:"7 \ud83d\udeaa Ingress",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},'##### Download NGINX images (online machine)\n#https://github.com/kubernetes/ingress-nginx\n#https://kubernetes.io/docs/concepts/services-networking/ingress/\n\nmkdir nginx\ncd nginx\n# download yaml descriptor:\nwget https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/1.24/deploy.yaml\n\n# download and save the images:\nsudo docker pull registry.k8s.io/ingress-nginx/controller:v1.3.0\nsudo docker pull registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1\nsudo docker save registry.k8s.io/ingress-nginx/controller:v1.3.0 > nginx-controller-v1.3.0.tar\nsudo docker save registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1 > kube-webhook-certgen-v1.5.0.tar\ncd ..\ntar -czvf nginx.tar.gz nginx\n#scp nginx.tar.gz root@master-k8s:~/lr-airgap\n\n##############################################################\n# NOTE: if ERROR with certificates when pulling images from k8s registry, follow this steps:\nmkdir -p /etc/docker/certs.d/registry.k8s.io\n# Download the certificates https://stackoverflow.com/a/70011298/5078874\nopenssl s_client -showcerts \\\n-connect registry.k8s.io:443 </dev/null 2>/dev/null \\\n| sed -n \'/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p\'  > ~/registry-k8s.crt\n# move the certificate to /etc/docker/certs.d/registry.k8s.io\n# https://velaninfo.com/rs/techtips/docker-certificate-authority/\n# https://www.ibm.com/docs/en/cloud-paks/cp-management/2.2.x?topic=tcnm-logging-into-your-docker-registry-fails-x509-certificate-signed-by-unknown-authority-error\nmv ~/registry-k8s.crt /etc/docker/certs.d/registry.k8s.io/\n# Create file /etc/docker/daemon.json and add insecure-registries\nsudo bash -c \'cat <<EOF >  /etc/docker/daemon.json\n{ "insecure-registries" : ["registry.k8s.io:443"] }\nEOF\'\n# restart the docker service\nsystemctl restart docker\n##############################################################\n\n\n##### Load NGINX images (offline machine)\n\ncd ~/lr-airgap/\ntar -xzvf nginx.tar.gz -C ~/lr-airgap\ncd nginx\n# unpack and load images\nfor x in *.tar; do sudo docker load < $x && echo "loaded from file $x"; done;\n'))),(0,r.kt)(l.Z,{value:"deploy-cluster",label:"8 \ud83d\ude80 Kubernetes",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},"## Deploying Kubernetes cluster (offline machine)\n\nsudo hostnamectl set-hostname 'master-k8s'\n# disable swap for the current session or comment out swap partitions or swap file from fstab file\nswapoff -a\n# Ensure that SELinux is in permissive mode\nsetenforce 0\n#https://stackoverflow.com/a/18836896/5078874\n#sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config\n# assuming the file does not exist\nsudo touch /etc/selinux/config\nsudo bash -c 'cat <<EOF >  /etc/selinux/config\nSELINUX=permissive\nEOF'\nsudo bash -c 'cat <<EOF >  /etc/sysctl.d/k8s.conf\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nEOF'\n\nsudo sysctl --system\n\n# In case you don\u2019t have your own dns server then update /etc/hosts file on master and worker nodes\nIP_NODE=$(ip addr show eth0 | grep \"inet\\b\" | awk '{print $2}' | cut -d/ -f1)\nsudo bash -c \"cat <<EOF >> /etc/hosts\n$(ip addr show eth0 | grep 'inet\\b' | awk '{print $2}' | cut -d/ -f1) $(hostname)\nEOF\"\n# More workers/masters here\n\n# configure kubectl autocompletion:\n#echo \"source <(kubectl completion bash)\" >> ~/.bashrc\n# Previous steps need to be done on each cluster's machine before continuing\n# enable kubelet service\nsudo systemctl enable kubelet.service\nkubectl version\n\n# Matching the container runtime and kubelet cgroup drivers is required, systemd driver is recommended for kubeadm based setups instead of the cgroupfs driver\n#https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/\ncat <<EOF >  kubeadm-config.yaml\n# kubeadm-config.yaml\nkind: ClusterConfiguration\napiVersion: kubeadm.k8s.io/v1beta3\nkubernetesVersion: v1.21.0\n---\nkind: KubeletConfiguration\napiVersion: kubelet.config.k8s.io/v1beta1\ncgroupDriver: systemd   # <--- driver\nEOF\n\n#https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/\n#kubeadm init --config kubeadm-config.yaml --pod-network-cidr=10.244.0.0/16 --kubernetes-version=v1.24.3 > ~/kubeadm.init.log\nsudo kubeadm init --apiserver-advertise-address=172.24.216.54 --pod-network-cidr=10.244.0.0/16 --kubernetes-version=v1.24.3 --cri-socket=unix:///var/run/cri-dockerd.sock  --ignore-preflight-errors=Mem > ~/kubeadm.init.log\n# IMPORTANT: ~/kubeadm.init.log generated file include the token required to join the worker nodes to the cluster\n# https://stackoverflow.com/a/72878730/5078874\n\n############### FOR THE WORKER\nkubeadm join 172.24.216.54:6443 --token YOUR.TOKEN \\\n        --discovery-token-ca-cert-hash sha256:YOUR-CERT \\\n        --kubernetes-version=v1.24.3 --cri-socket=unix:///var/run/cri-dockerd.sock\n###############\n\nmkdir -p $HOME/.kube\nsudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config\nsudo chown $(id -u):$(id -g) $HOME/.kube/config\n\n# verify the node is running:\nkubectl get nodes\n# configure kubectl to manage your cluster:\ngrep -q \"KUBECONFIG\" ~/.bashrc || {\n    echo 'export KUBECONFIG=$HOME/.kube/config' >> ~/.bashrc\n    . ~/.bashrc\n}\n\ncd ~/lr-airgap/\n# initiate the Flannel network in Control Plane node:\nkubectl apply -f kube-flannel.yml\n# for security reasons, the cluster does not schedule pods on the Control plane node by default.\n\n# ONLY IF YOU WANT A SINGLE NODE CLUSTER\n# Executing this command removes the node-role.kubernetes.io/master \n# taint from any nodes that have it, so that the scheduler can schedule pods everywhere:\n#kubectl taint nodes --all node-role.kubernetes.io/master-\n"))),(0,r.kt)(l.Z,{value:"join-nodes",label:"9 \ud83d\udc77\ud83c\udffd Worker Nodes",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},'### Join worker nodes to the cluster\n\n# Find the join command string saved in a previous step in file: ~/kubeadm.init.log\ngrep "kubeadm join" ~/kubeadm.init.log\n\n# Verify nodes and components:\nkubectl get nodes\nkubectl get componentstatuses\n'))),(0,r.kt)(l.Z,{value:"test",label:"10 \ud83e\uddea Test",mdxType:"TabItem"},(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-sh"},"## Tests\n\n### Smoke Tests\n#https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/docs/15-smoke-test.md\n\n### Run End-to-End Tests\n#https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/docs/16-e2e-tests.md\n#https://github.com/kubernetes/test-infra\n\n")))),(0,r.kt)("p",null,"You did it!"),(0,r.kt)("p",null,(0,r.kt)("strong",{parentName:"p"},"Don't forget to like the video and share if you learned somemthing useful.")," \ud83e\udd13"),(0,r.kt)("h3",{id:"bonus"},"Bonus"),(0,r.kt)("p",null,"You can also dowload the scripts I created based on the lab you just completed above."),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{target:"_blank",href:t(9839).Z},"master-k8s-airgap.sh")," - Airgapped master node"),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{target:"_blank",href:t(4247).Z},"master-k8s-internet.sh")," - If you have access to the Internet"),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{target:"_blank",href:t(5593).Z},"worker-k8s-airgap.sh")," - Airgapped worker node")),(0,r.kt)("p",null,"References:  "),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{parentName:"li",href:"https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository"},"install-using-the-repository"))))}b.isMDXComponent=!0},9839:(e,n,t)=>{t.d(n,{Z:()=>s});const s=t.p+"assets/files/master-k8s-airgap-7261e5bf2241d985cff0a2b9b6d42525.sh"},4247:(e,n,t)=>{t.d(n,{Z:()=>s});const s=t.p+"assets/files/master-k8s-internet-fa73cff7186f14ed3257c5eb041f01e1.sh"},5593:(e,n,t)=>{t.d(n,{Z:()=>s});const s=t.p+"assets/files/worker-k8s-airgap-020b369c9c64991a01add8a19ffed706.sh"}}]);