#!/bin/bash
export SERVER_IP="192.168.0.200"
export NODE1_IP="192.168.0.201"
export NODE2_IP="192.168.0.202"
# Step1: Download the k3ups binary on k3sup node
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/
k3sup --help
# Step2: Create the k3s cluster - Server
echo "export SERVER_IP=192.168.0.200" | sudo tee -a /home/$USER/.bashrc
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
k3sup install --ip ${SERVER_IP} --user vagrant
#k3sup install --ip ${SERVER_IP} --user vagrant --local-path=./kubeconfig --k3s-version=0.9.1 --k3s-extra-args "--flannel-iface=enp0s8"
echo "export KUBECONFIG=`pwd`/kubeconfig" | sudo tee -a /home/$USER/.bashrc
# Step3: Create the k3s cluster - Nodes
echo "export NODE1_IP=192.168.0.201" | sudo tee -a /home/$USER/.bashrc
k3sup join --ip ${NODE1_IP} --server-ip ${SERVER_IP} --user vagrant
#k3sup join --ip ${NODE1_IP} --server-ip ${SERVER_IP} --user vagrant --k3s-version=0.9.1 --k3s-extra-args "--flannel-iface=enp0s8"
echo "export NODE2_IP=192.168.0.202" | sudo tee -a /home/$USER/.bashrc
k3sup join --ip ${NODE2_IP} --server-ip ${SERVER_IP} --user vagrant
#k3sup join --ip ${NODE2_IP} --server-ip ${SERVER_IP} --user vagrant --k3s-version=0.9.1 --k3s-extra-args "--flannel-iface=enp0s8"
