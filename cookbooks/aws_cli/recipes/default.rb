# Install zip
package "zip"

directory "/home/#{node[:so_user]}/awscli" do
	action :create
	owner "#{node[:so_user]}"
	group "#{node[:so_user]}"
end

directory "/home/#{node[:so_user]}/.aws" do
  action :create
  owner "#{node[:so_user]}"
  group "#{node[:so_user]}"
end

# file keys aws
cookbook_file "/home/#{node[:so_user]}/.aws/config" do
  mode '0644'
  source "config"
  owner "#{node[:so_user]}"
  group "#{node[:so_user]}"
end

# Install aws_cli
bash "descarga descomprime awscli" do
  flags '-l'
  code <<-EOH
          wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
        	unzip awscli-bundle.zip
   			  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
           EOH
  cwd   "/home/#{node[:so_user]}/awscli"
   not_if {::File.exists? "/usr/local/aws"}
end