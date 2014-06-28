# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    # Base box
    config.vm.box = "hashicorp/precise64"

    # Fine tune VBox
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
    end

    # Sync folders in NFS
    config.vm.synced_folder ".", "/vagrant", type: "nfs"

    # Use password for SSH, needed for tools like Sequel Pro
    config.ssh.password = "vagrant"

    # Set host-only access IP
    config.vm.network "private_network", ip: "192.168.76.67"

    # Host post 7667 is for "soon" on a phone keyboard...
    config.vm.network :forwarded_port, host: 7667, guest: 80

    # Provisionning
    config.vm.provision :shell, path: "bootstrap.sh"

end
