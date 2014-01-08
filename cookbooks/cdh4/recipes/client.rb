#
# Cookbook Name:: cdh4
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'cdh4'

package 'hadoop-client'

include_recipe 'cdh4::cluster'

link "/usr/lib/hadoop/hadoop-streaming-2.0.0-mr1-#{node.cdh4.dist}.jar" do
  to "/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-#{node.cdh4.dist}.jar"
end

template '/etc/hadoop/conf.cluster/core-site.xml' do
  source 'front/core-site.xml.erb'
  mode 0644
end

template '/etc/hadoop/conf.cluster/hdfs-site.xml' do
  source 'front/hdfs-site.xml.erb'
  mode 0644
end

template '/etc/hadoop/conf.cluster/mapred-site.xml' do
  source 'front/mapred-site.xml.erb'
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
