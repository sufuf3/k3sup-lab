default_box = 'ubuntu/bionic64'

Vagrant.configure(2) do |config|

  #config.vm.box_check_update = false
  #config.vbguest.auto_update = false

  config.vm.define "k3sup-host" do |node|
    unless File.exist?("keys/id_rsa.pub")
      `ssh-keygen -b 2048 -f keys/id_rsa -t rsa -q -N ''`
    end
    config.vm.provision "file", source: "keys/id_rsa.pub", destination: "id_rsa.pub"
    config.vm.provision "file", source: "keys/id_rsa", destination: "id_rsa"
    config.vm.provision "file", source: "k3sup-cluster.sh", destination: "k3sup-cluster.sh"
    #config.vm.provision "append-public-key", :type => "shell", inline: "cat id_rsa.pub | tee -a ~/.ssh/id_rsa.pub"
    #config.vm.provision "append-public-key", :type => "shell", inline: "cat id_rsa.pub | tee -a ~/.ssh/authorized_keys"
    #config.vm.provision "append-public-key", :type => "shell", inline: "mv id_rsa ~/.ssh/id_rsa"
    node.vm.box = default_box
    node.vm.synced_folder ".", "/vagrant", type:"virtualbox"
    node.vm.network "private_network", ip: "192.168.0.199",  virtualbox__intnet: true
    node.vm.provider "virtualbox" do |v|
      v.memory = "800"
      v.name = "k3sup-host"
      end

    node.vm.provision "shell", inline: <<-SHELL
      IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
      cat ~/id_rsa.pub | tee -a /home/vagrant/.ssh/authorized_keys
      export UBUNTU_APT_SITE=free.nchc.org.tw
      sed -i 's/^deb-src\ /\#deb-src\ /g' /etc/apt/sources.list
      sed -E -i "s/([a-z]+.)?archive.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
      sed -i "s/security.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
      sudo apt-get update
      echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
      echo "AuthorizedKeysFile     .ssh/authorized_keys" | sudo tee -a /etc/ssh/sshd_config
      sudo service ssh restart
      echo "Host 192.168.0.*" | tee -a ssh-config
      echo "    StrictHostKeyChecking no" | tee -a ssh-config
      echo "    UserKnownHostsFile=/dev/null" | tee -a ssh-config
    SHELL
  end

  config.vm.define "k3sup-master" do |master|
    config.vm.provision "file", source: "keys/id_rsa.pub", destination: "id_rsa.pub"
    #config.vm.provision "append-public-key", :type => "shell", inline: "mv id_rsa.pub ~/.ssh/authorized_keys"
    master.vm.box = default_box
    master.vm.hostname = "k3sup-master"
    master.vm.synced_folder ".", "/vagrant", type:"virtualbox"
    master.vm.network "private_network", ip: "192.168.0.200",  virtualbox__intnet: true
    master.vm.network "forwarded_port", guest: 6443, host: 6443 # ACCESS K8S API
    for p in 30000..30100 # PORTS DEFINED FOR K8S TYPE-NODE-PORT ACCESS
      master.vm.network "forwarded_port", guest: p, host: p, protocol: "tcp"
      end
    master.vm.provider "virtualbox" do |v|
      v.memory = "700"
      v.name = "k3sup-master"
      end

    master.vm.provision "shell", inline: <<-SHELL
      IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
      cat ~/id_rsa.pub | tee -a /home/vagrant/.ssh/authorized_keys
      hostnamectl set-hostname k3sup-master
      echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
      echo "AuthorizedKeysFile     .ssh/authorized_keys" | sudo tee -a /etc/ssh/sshd_config
      sudo service ssh restart
      export UBUNTU_APT_SITE=free.nchc.org.tw
      sed -i 's/^deb-src\ /\#deb-src\ /g' /etc/apt/sources.list
      sed -E -i "s/([a-z]+.)?archive.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
      sed -i "s/security.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
      sudo apt-get update
    SHELL
  end

  (1..2).each do |i|
    config.vm.define "node-#{i}" do |node|
      config.vm.provision "file", source: "keys/id_rsa.pub", destination: "id_rsa.pub"
      #config.vm.provision "append-public-key", :type => "shell", inline: "mv id_rsa.pub ~/.ssh/authorized_keys"
      node.vm.box = default_box
      node.vm.hostname = "node-#{i}"
      node.vm.synced_folder ".", "/vagrant", type:"virtualbox"
      node.vm.network 'private_network', ip: "192.168.0.20#{i + 1}",  virtualbox__intnet: true
      node.vm.provider "virtualbox" do |v|
        v.memory = "512"
        v.name = "node-#{i}"
        end

      node.vm.provision "shell", inline: <<-SHELL
        IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
        cat ~/id_rsa.pub | tee -a /home/vagrant/.ssh/authorized_keys
        echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
        echo "AuthorizedKeysFile     .ssh/authorized_keys" | sudo tee -a /etc/ssh/sshd_config
        sudo service ssh restart
        export UBUNTU_APT_SITE=free.nchc.org.tw
        sed -i 's/^deb-src\ /\#deb-src\ /g' /etc/apt/sources.list
        sed -E -i "s/([a-z]+.)?archive.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
        sed -i "s/security.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
        sudo apt-get update
      SHELL
    end
  end

end
