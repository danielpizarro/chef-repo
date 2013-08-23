#
# Cookbook Name:: cdh4
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'cdh4::client'

template '/etc/hadoop/conf.cluster/core-site.xml' do
  source 'master/core-site.xml.erb'
  mode 0644
end

template '/etc/hadoop/conf.cluster/hdfs-site.xml' do
  source 'master/hdfs-site.xml.erb'
  mode 0644
end

template '/etc/hadoop/conf.cluster/mapred-site.xml' do
  source 'master/mapred-site.xml.erb'
  mode 0644
end

template '/etc/hadoop/conf.cluster/masters' do
  source 'master/masters'
  mode 0644
end

template '/etc/hadoop/conf.cluster/slaves' do
  source 'master/slaves'
  mode 0644
end

template '/etc/hadoop/conf.cluster/log4j.properties' do
  source 'log4j.properties'
  mode 0644
end

template '/etc/hadoop/conf.cluster/hadoop-metrics2.properties' do
  source 'hadoop-metrics.properties'
  mode 0644
end

services = ['hadoop-hdfs-namenode', 'hadoop-hdfs-secondarynamenode', 'hadoop-0.20-mapreduce-jobtracker']

services.each do |daemon|
  package daemon do
    options "--force-yes"
  end
end

execute 'sudo -u hdfs hdfs namenode -format -noninteractive' do
  returns [0, 1]
end

service 'hadoop-hdfs-namenode' do
  action [:enable, :start]
end

service 'hadoop-hdfs-secondarynamenode' do
  action [:enable, :start]
end

execute 'sudo -u hdfs hadoop fs -mkdir -p /tmp'
execute 'sudo -u hdfs hadoop fs -chmod -R 1777 /tmp'
execute 'sudo -u hdfs hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging'
execute 'sudo -u hdfs hadoop fs -chown mapred:hadoop /var/lib/hadoop-hdfs/cache/mapred/mapred/staging'
execute 'sudo -u hdfs hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/system'
execute 'sudo -u hdfs hadoop fs -chown mapred:hadoop /var/lib/hadoop-hdfs/cache/mapred/mapred/system'
execute 'sudo -u hdfs hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred'

link '/usr/lib/hadoop/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar' do
  to '/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar'
end

service 'hadoop-0.20-mapreduce-jobtracker' do
  action [:enable, :start]
end
