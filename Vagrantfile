system('[ ! -d forVm ] && mkdir forVm')
Vagrant.configure(2) do |config|
	config.vm.define "terraformBox" do |devbox|
		#devbox.vm.box = "bento/ubuntu-18.04"
		devbox.vm.box = "generic/ubuntu1804"
    		devbox.vm.network "private_network", ip: "172.3.4.5"
    		devbox.vm.hostname = "terraformBox"
      		devbox.vm.provision "shell", path: "scripts/install.sh"
            # config.vm.synced_folder "~/work-terraform/", "/home/vagrant/forVm"
    		devbox.vm.provider "virtualbox" do |v|
    		  v.memory = 4096
    		  v.cpus = 2
    		end
	end
end
