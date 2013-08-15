#
# Cookbook Name:: cdh4
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'cdh4'

services = ['hadoop-hdfs-namenode', 'hadoop-hdfs-secondarynamenode', 'hadoop-0.20-mapreduce-jobtracker']

services.each do |daemon|
  package daemon do
    options "--force-yes"
  end
end

include_recipe 'cdh4::cluster'

template '/etc/hadoop/conf.cluster/core-site.xml' do
  source 'core-site.xml.erb'
  mode 0755
end

template '/etc/hadoop/conf.cluster/hdfs-site.xml' do
  source 'hdfs-site.xml.erb'
  mode 0755
end

template '/etc/hadoop/conf.cluster/mapred-site.xml' do
  source 'mapred-site.xml.erb'
  mode 0755
end

directory '/var/lib/hadoop-data/dfs/nn' do
  owner 'hdfs'
  group 'hdfs'
  mode 0700
  recursive true
end

execute 'sudo -u hdfs hdfs namenode -format -noninteractive' do
  returns [0, 1]
end

execute 'sudo -u hdfs hadoop fs -mkdir -p /tmp'
execute 'sudo -u hdfs hadoop fs -chmod -R 1777 /tmp'

services.each do |daemon|
  service daemon do
    action [:enable, :start]
  end
end
