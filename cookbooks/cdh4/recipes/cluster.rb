#
# Cookbook Name:: cdh4
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/etc/hadoop/conf.cluster" do
  owner 'root'
  group 'hadoop'
  mode 0755
end

execute "update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50"
execute "update-alternatives --set hadoop-conf /etc/hadoop/conf.cluster"


# # Core Site
# template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/core-site.xml" do
#   source "core-site.xml.erb"
# end

# # HDFS Site
# template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/hdfs-site.xml" do
#   source "hdfs-site.xml.erb"
# end

# # MapRed Site
# template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/mapred-site.xml" do
#   source "mapred-site.xml.erb"
# end

# # FairScheduler config
# template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/fair-scheduler.xml" do
#   source "fair-scheduler.xml.erb"
# end

# # Masters
# template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/masters" do
#   source "masters.erb"
# end

# # Slaves
# template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/slaves" do
#   source "slaves.erb"
# end

# script "Give proper permissions" do
#   user "root"
#   interpreter "bash"
#   code <<-EOH
#     chmod -R 755 /etc/hadoop-0.20/#{node['hadoop']['conf_name']}/*
#     chown -R root:hadoop /etc/hadoop-0.20/#{node['hadoop']['conf_name']}/*
#   EOH
# end


# script "echo conf alternatives" do
#   interpreter "bash"
#   user "root"
#   code <<-EOH
#   echo "**** CONFIG CREATED **** Now run 'alternatives --set hadoop-0.20-conf /etc/hadoop-0.20/#{node['hadoop']['conf_name']}' to enable config"
#   EOH
# end