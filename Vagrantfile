# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "dummy-aws"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']
    aws.region = ENV['AWS_REGION']
    aws.ami = ENV['AWS_AMI_ID']
    aws.instance_type = "t2.micro"
    aws.keypair_name = ENV['AWS_KEYPAIR']
    aws.security_groups = [ ENV['AWS_SECURITY_GROUP'] ]
    aws.tags = { 'Name' => 'vagrant_test' }
    aws.terminate_on_shutdown = true
    override.ssh.username = "core"
    override.ssh.private_key_path = ENV['AWS_SSH_PEM_KEY']
  end
  config.vm.provision :docker do |d|
    d.build_image "/vagrant", args: "-t apache"
    d.run "apache", daemonize: true, args: "-p 80:80"
  end
end
