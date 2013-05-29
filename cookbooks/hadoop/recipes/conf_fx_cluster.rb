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

include_recipe "hadoop"
package "hadoop-0.20-conf-pseudo"

remote_directory "/etc/hadoop-0.20/conf.fx_cluster" do
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
    alternatives --install /etc/hadoop-0.20/conf hadoop-0.20-conf /etc/hadoop-0.20/conf.fx_cluster 60
    alternatives --set hadoop-0.20-conf /etc/hadoop-0.20/conf.fx_cluster
    EOH
  end
when "debian","ubuntu"
  execute "update-alternatives --install /etc/hadoop-0.20/conf hadoop-0.20-conf /etc/hadoop-0.20/conf.fx_cluster 60"  do
    user "root"
  end
end

# Core Site
template "/etc/hadoop-0.20/conf.fx_cluster/core-site.xml" do
  source "core-site.xml.erb"
end

# HDFS Site
template "/etc/hadoop-0.20/conf.fx_cluster/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
end

# MapRed Site
template "/etc/hadoop-0.20/conf.fx_cluster/mapred-site.xml" do
  source "mapred-site.xml.erb"
end

# FairScheduler config
template "/etc/hadoop-0.20/conf.fx_cluster/fairscheduler_fx.xml" do
  source "fairscheduler_fx.xml.erb"
end

# Masters
template "/etc/hadoop-0.20/conf.fx_cluster/masters" do
  source "masters.erb"
end

# Slaves
template "/etc/hadoop-0.20/conf.fx_cluster/slaves" do
  source "slaves.erb"
end

script "Give proper permissions" do
  user "root"
  interpreter "bash"
  code <<-EOH
    chmod -R 755 /etc/hadoop-0.20/conf.fx_cluster/*
    chown -R root:hadoop /etc/hadoop-0.20/conf.fx_cluster/*
  EOH
end

# Create dirs
# HDFS Name Dir
node['hadoop']['hdfs']['name_dir'].split(",").each do |dir|
  script "Create namedir" do
    user "root"
    interpreter "bash"
    code <<-EOH
      mkdir -p #{dir}
      chown -R hdfs:hadoop #{dir}
    EOH
  end
end
# HDFS Data Dir
script "Create datadir" do
  user "root"
  interpreter "bash"
  code <<-EOH
    mkdir -p #{node['hadoop']['hdfs']['data_dir']}
    chown -R hdfs:hadoop #{node['hadoop']['hdfs']['data_dir']}
  EOH
end
# MapRed Local Dir
script "Create local dir" do
  user "root"
  interpreter "bash"
  code <<-EOH
    mkdir -p #{node['hadoop']['mapred']['local_dir']}
    chown -R mapred:hadoop #{node['hadoop']['mapred']['local_dir']}
  EOH
end