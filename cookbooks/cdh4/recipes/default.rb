#
# Cookbook Name:: cdh4
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'java::oracle'

execute "apt-get update" do
  action :nothing
end

template "/etc/apt/sources.list.d/cloudera.list" do
  owner "root"
  mode "0644"
  source "cloudera.list.erb"
end

package 'curl'
execute "curl -s http://archive.cloudera.com/cdh4/ubuntu/#{node.lsb.codename}/amd64/cdh/archive.key | apt-key add -" do
  notifies :run, resources('execute[apt-get update]'), :immediately
  not_if "apt-key list | grep 'Cloudera Apt Repository'"
end
