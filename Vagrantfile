# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.7.0"

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/ubuntu-14.04"

  if Vagrant.has_plugin? 'vagrant-omnibus'
    # Set Chef version for Omnibus
    config.omnibus.chef_version = :latest
  else
    raise Vagrant::Errors::VagrantError.new,
      "vagrant-omnibus missing, please install the plugin:\n" +
      "vagrant plugin install vagrant-omnibus"
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  # Forward MySql port on 33066, used for connecting admin-clients to localhost:33066
  config.vm.network :forwarded_port, guest: 3306, host: 33066
  # Forward http port on 8080, used for connecting web browsers to localhost:8080
  config.vm.network :forwarded_port, guest: 80, host: 8080
  # Forward http port on 8025, used for connecting web browsers to MailHog
  config.vm.network :forwarded_port, guest: 8025, host: 8025

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.33.10"

  # Mount share folder over nfs (has performance advantages with large number of projects)
  config.vm.synced_folder "./", "/vagrant/", id: "vagrant-root", :nfs => true
  # /var/log over NFS will not work, probably something to do with trying to mount something on a location that already exists.
  config.vm.synced_folder "vagrant-logs/", "/var/log/", id: "vagrant-logs", :owner=> 'vagrant', :group=>'www-data', :mount_options => ["dmode=775", "fmode=664"]

  # Create a persistent storage for MySQL. See https://github.com/kusnier/vagrant-persistent-storage
  if defined? VagrantPlugins::PersistentStorage
    config.persistent_storage.enabled = true
    config.persistent_storage.location = "vagrant-mysql.vdi"
    config.persistent_storage.size = 20000
    config.persistent_storage.mountname = 'mysql'
    config.persistent_storage.filesystem = 'ext4'
    config.persistent_storage.mountpoint = '/var/lib/mysql'
    config.persistent_storage.volgroupname = 'vagrant'
  end

  # Provider-specific configuration so you can fine-tune VirtualBox for Vagrant.
  # These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM.
    # For example to change memory or number of CPUs:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

  # Enable provisioning with chef zero, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = ["berks-cookbooks", "cookbooks"] 
    chef.data_bags_path = "data_bags"

    # List of recipes to run
    chef.add_recipe "vagrant_main"
    chef.add_recipe "vagrant_main::nodejs"
    chef.add_recipe "vagrant_main::wordpress"
    chef.add_recipe "vagrant_main::magento"
  end

  # Make sure apache is restarted even if the previous block does not run for
  # boxes that have already been provisioned
  config.vm.provision :shell, run: "always", inline: "sudo /etc/init.d/apache2 restart"

end
