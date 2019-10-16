#!/bin/bash
#
# $ kubectl get no
# NAME           STATUS   ROLES    AGE     VERSION
# node-2         Ready    worker   30s     v1.15.4-k3s.1
# node-1         Ready    worker   4m54s   v1.15.4-k3s.1
# k3sup-master   Ready    master   8m7s    v1.15.4-k3s.1

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
