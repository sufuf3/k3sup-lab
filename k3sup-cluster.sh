#!/bin/bash
#
# $ kubectl get no -o wide
# NAME           STATUS   ROLES    AGE   VERSION         INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
# node-2         Ready    worker   23m   v1.15.4-k3s.1   192.168.0.203   <none>        Ubuntu 18.04.3 LTS   4.15.0-64-generic   containerd://1.2.8-k3s.1
# node-1         Ready    worker   27m   v1.15.4-k3s.1   192.168.0.202   <none>        Ubuntu 18.04.3 LTS   4.15.0-64-generic   containerd://1.2.8-k3s.1
# k3sup-master   Ready    master   30m   v1.15.4-k3s.1   192.168.0.200   <none>        Ubuntu 18.04.3 LTS   4.15.0-64-generic   containerd://1.2.8-k3s.1

export SERVER_IP="192.168.0.200"
export NODE1_IP="192.168.0.202"
export NODE2_IP="192.168.0.203"
echo "export SERVER_IP=192.168.0.200" | sudo tee -a /home/$USER/.bashrc
echo "export NODE1_IP=192.168.0.202" | sudo tee -a /home/$USER/.bashrc
echo "export NODE2_IP=192.168.0.203" | sudo tee -a /home/$USER/.bashrc
echo "export KUBECONFIG=`pwd`/kubeconfig" | sudo tee -a /home/$USER/.bashrc
# Step1: Download the k3ups binary on k3sup node
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/
k3sup --help
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# Step2: Create the k3s cluster - Server
k3sup install --ip ${SERVER_IP} --user vagrant --k3s-version v0.9.1 --k3s-extra-args '--flannel-iface enp0s8'
# Step3: Create the k3s cluster - Nodes
k3sup join --ip ${NODE1_IP} --server-ip ${SERVER_IP} --user vagrant --k3s-version v0.9.1 --k3s-extra-args '--flannel-iface enp0s8'
k3sup join --ip ${NODE2_IP} --server-ip ${SERVER_IP} --user vagrant --k3s-version v0.9.1 --k3s-extra-args '--flannel-iface enp0s8'
