#vagrant plugin install vagrant-vbguest
# Step1: Create 3 Hosts for a k3s cluster, 1 host for install k3sup
vagrant up

vagrant ssh k3sup-host --command 'cat ~/id_rsa.pub | tee -a /home/vagrant/.ssh/authorized_keys'
vagrant ssh k3sup-host --command 'cat ~/ssh-config | tee -a /home/vagrant/.ssh/config'
vagrant ssh k3sup-host --command 'sudo chown vagrant:vagrant /home/vagrant/id_rsa.pub'
vagrant ssh k3sup-host --command 'sudo chown vagrant:vagrant /home/vagrant/id_rsa'
vagrant ssh k3sup-host --command 'cp /home/vagrant/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub'
vagrant ssh k3sup-host --command 'cp /home/vagrant/id_rsa /home/vagrant/.ssh/id_rsa'
vagrant ssh k3sup-master --command 'cat ~/id_rsa.pub | tee -a /home/vagrant/.ssh/authorized_keys'
vagrant ssh node-1 --command 'cat ~/id_rsa.pub | tee -a /home/vagrant/.ssh/authorized_keys'
vagrant ssh node-2 --command 'cat ~/id_rsa.pub | tee -a /home/vagrant/.ssh/authorized_keys'
vagrant ssh k3sup-host --command 'sh k3sup-cluster.sh'
# Step2: Download the k3ups binary on k3sup node
#vagrant ssh k3sup-host --command 'curl -sLS https://get.k3sup.dev | sh'
#vagrant ssh k3sup-host --command 'sudo install k3sup /usr/local/bin/'
#vagrant ssh k3sup-host --command 'k3sup --help'
# Step3: Create the k3s cluster - Server
#vagrant ssh k3sup-host --command 'echo "export SERVER_IP=192.168.0.200" | sudo tee -a /home/$USER/.bashrc'
vagrant ssh k3sup-host --command 'export SERVER_IP="192.168.0.200" && k3sup install --ip ${SERVER_IP} --user vagrant'
#vagrant ssh k3sup-host --command 'export SERVER_IP="192.168.0.200" && k3sup install --ip ${SERVER_IP} --user vagrant --local-path=./kubeconfig --k3s-version=0.9.1 --k3s-extra-args "--flannel-iface=enp0s8"'
#vagrant ssh k3sup-host --command 'echo "export KUBECONFIG=`pwd`/kubeconfig" | sudo tee -a /home/$USER/.bashrc'
# Step4: Create the k3s cluster - Nodes
#vagrant ssh k3sup-host --command 'echo "export NODE1_IP=192.168.0.201" | sudo tee -a /home/$USER/.bashrc'
#vagrant ssh k3sup-host --command 'export NODE1_IP="192.168.0.201" && export SERVER_IP="192.168.0.200" && k3sup join --ip ${NODE1_IP} --server-ip ${SERVER_IP} --user vagrant --k3s-version=0.9.1 --k3s-extra-args "--flannel-iface=enp0s8"'
#vagrant ssh k3sup-host --command 'echo "export NODE2_IP=192.168.0.202" | sudo tee -a /home/$USER/.bashrc'
#vagrant ssh k3sup-host --command 'export NODE1_IP="192.168.0.202" && export SERVER_IP="192.168.0.200" && k3sup join --ip ${NODE2_IP} --server-ip ${SERVER_IP} --user vagrant --k3s-version=0.9.1 --k3s-extra-args "--flannel-iface=enp0s8"'
