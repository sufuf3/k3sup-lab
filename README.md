# k3sup Lab via Vagrant

> 1 node for inatall k3sup, 3 nodes as a k3s cluster

## Setup

```sh
git clone https://github.com/sufuf3/k3sup-lab.git
cd k3sup-lab/ && sh deploy-vagrant.sh
```

## Verification

```sh
# vagrant ssh k3sup-host
vagrant@ubuntu-bionic:~$ kubectl get no
NAME           STATUS   ROLES    AGE   VERSION
node-2         Ready    worker   40m   v1.15.4-k3s.1
node-1         Ready    worker   45m   v1.15.4-k3s.1
k3sup-master   Ready    master   47m   v1.15.4-k3s.1
```
