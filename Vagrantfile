require 'berkshelf/vagrant'

boxname = ENV['PLAYGROUND_BOXNAME'] || "opscode_ubuntu-12.04"
chef_version = ENV['PLAYGROUND_CHEF'] || "10.18.2"

current_dir = File.dirname(__FILE__)

host_cache_path = File.join(current_dir,
                            "cache")

validation_key_path = File.join(host_cache_path,
                                "chef-validator.pem")

guest_cache_path = "/tmp/chef-vagrant-cache"

# ensure the cache path exists
FileUtils.mkdir(host_cache_path) unless File.exist?(host_cache_path)

Vagrant::Config.run do |config|
  config.vm.customize ["modifyvm", :id, "--cpus", 2]
  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  config.vm.host_name = "chef-server-berkshelf"

  config.vm.box = "#{boxname}"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/#{boxname}_chef-#{chef_version}.box"

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
  config.ssh.forward_agent = true

  config.vm.define :chef_server do |vm_config|
    vm_config.vm.forward_port 443, 4443
    vm_config.vm.host_name = "chef-server-berkshelf"
    vm_config.vm.network :hostonly, "33.33.33.10"
    vm_config.vm.share_folder "cache", guest_cache_path, host_cache_path
    vm_config.vm.provision :shell, :path => "scripts/add_chef_server_etc_hosts.sh"
    vm_config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = {
        "chef-server" => {
          "version" => "latest",
          "prereleases" => true,
          "nightlies" => true
        }
      }
      chef.run_list = [
                       "recipe[chef-server::default]"
                      ]
    end
    # Copy over the validator pem, admin pem, so Knife works in the
    # parent directory
    vm_config.vm.provision :shell, :path => "scripts/chef_postinstall_script.sh"
  end

  config.vm.define :test_server do |vm_config|
    vm_config.vm.host_name = "test-server"
    vm_config.vm.network :hostonly, "33.33.33.40"
    vm_config.vm.provision :shell, :path => "scripts/add_chef_server_etc_hosts.sh"
    vm_config.vm.provision :chef_client do |chef|
      chef.chef_server_url = "https://chef-server-berkshelf"
      chef.validation_client_name = "chef-validator"
      chef.validation_key_path = validation_key_path
    end
  end

end
