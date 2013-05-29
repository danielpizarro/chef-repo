#
# Cookbook Name:: hadoop
# Recipe:: conf_pseudo
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

remote_directory "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}" do
  source "conf.fx_cluster"
  files_owner "root"
  files_group "root"
  files_mode "0755"
  owner "root"
  group "root"
  mode "0755"
end

case node[:platform]
when "centos","redhat","fedora","suse"
  script "update hadoop conf alternatives" do
    interpreter "bash"
    user "root"
    code <<-EOH
    . ~/.bashrc
    alternatives --install /etc/hadoop-0.20/conf hadoop-0.20-conf /etc/hadoop-0.20/#{node['hadoop']['conf_name']} 40
    EOH
  end
when "debian","ubuntu"
  execute "update-alternatives --install /etc/hadoop-0.20/conf hadoop-0.20-conf /etc/hadoop-0.20/#{node['hadoop']['conf_name']} 40"  do
    user "root"
  end
end

# Core Site
template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/core-site.xml" do
  source "core-site.xml.erb"
end

# HDFS Site
template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
end

# MapRed Site
template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/mapred-site.xml" do
  source "mapred-site.xml.erb"
end

# FairScheduler config
template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/fair-scheduler.xml" do
  source "fair-scheduler.xml.erb"
end

# Masters
template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/masters" do
  source "masters.erb"
end

# Slaves
template "/etc/hadoop-0.20/#{node['hadoop']['conf_name']}/slaves" do
  source "slaves.erb"
end

script "Give proper permissions" do
  user "root"
  interpreter "bash"
  code <<-EOH
    chmod -R 755 /etc/hadoop-0.20/#{node['hadoop']['conf_name']}/*
    chown -R root:hadoop /etc/hadoop-0.20/#{node['hadoop']['conf_name']}/*
  EOH
end


script "echo conf alternatives" do
  interpreter "bash"
  user "root"
  code <<-EOH
  echo "**** CONFIG CREATED **** Now run 'alternatives --set hadoop-0.20-conf /etc/hadoop-0.20/#{node['hadoop']['conf_name']}' to enable config"
  EOH
end