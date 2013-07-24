# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  ## Options below here usually don't need tweaking.  An exception would be for provisioning nodes in Amazon EC2.
  config.vm.box = "precise64-ubuntu-12.04LTS"
  config.vm.box_url = "https://s3-us-west-2.amazonaws.com/squishy.vagrant-boxes/precise64_squishy_2013-02-09.box"
  # config.vm.box = "quantal64-cloudimage-12.10"
  # config.vm.box_url = "http://cloud-images.ubuntu.com/quantal/current/quantal-server-cloudimg-vagrant-amd64-disk1.box"

  # VirtualBox configuration tweaks
  config.vm.provider :virtualbox do |v|
    # Leverage this Host OS's resolve.  This includes /etc/hosts entries
    v.customize ["modifyvm", :id, "--natdnshostresolver1","on"]
    # Memory customization doesn't work at the global level so we do it in each VM definition below.
    # v.customize ["modifyvm", :id, "--memory",256]
    v.gui = false
  end
  
  # AWS configuration tweaks
  #
  # Don't put security credentials directly in this file!
  # Create a new AWS user at https://console.aws.amazon.com/iam/home?#users and 
  # download the credentials to ~/ec2/training.csv 
  #
  aws_credential_file = ::File.expand_path("~/.ec2/training.csv")
  if (::File.exists?(aws_credential_file)) 
    require 'csv'
    aws_credentials = ::CSV.table(aws_credential_file)
    puts "AWS credentials:" + aws_credentials[0][:access_key_id] + " " + aws_credentials[0][:secret_access_key]
  end
  
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = aws_credentials[0][:access_key_id]
    aws.secret_access_key = aws_credentials[0][:secret_access_key]
    aws.instance_type = "m1.large"
    # Create a security group with all TCP, UDP, and ICMP ports open. 
    #  You shouldn't do this for most servers, but it's OK for the training class.
    aws.security_groups = "insecure"

    aws.region = "us-west-1"
    aws.ami = "ami-c0eac285"
    # Create a key pair and download the .pem to ~/.ec2 -- reference it below
    aws.keypair_name = "training"
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "#{ENV['HOME']}/.ec2/training.pem"
  end

  config.vm.define :combined do |my|
    my.vm.network :private_network, ip: "172.16.1.10"
    my.vm.hostname = "combined"
    my.vm.provider :virtualbox do |vbox|
      vbox.name = my.vm.hostname
      vbox.customize ["modifyvm", :id, "--memory",256]
    end
    my.vm.provision :puppet do |puppet|
      puppet.manifests_path = "."
      puppet.module_path = "modules"
      puppet.manifest_file = "combined.pp"
    end
  end
end
