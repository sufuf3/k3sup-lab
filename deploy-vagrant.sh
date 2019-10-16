vagrant plugin install vagrant-vbguest
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
