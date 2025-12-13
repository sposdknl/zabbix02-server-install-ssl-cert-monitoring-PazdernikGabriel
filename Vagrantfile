Vagrant.configure("2") do |config|
config.vm.box = "ubuntu/jammy64"


config.vm.provider "virtualbox" do |vb|
vb.memory = "2048"
vb.cpus = 2
end


config.vm.network "forwarded_port", guest: 80, host: 8080
config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh"


config.vm.provision "shell", path: "provision.sh"
end