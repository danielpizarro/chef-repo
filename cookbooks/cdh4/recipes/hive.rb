#
# Cookbook Name:: cdh4
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'cdh4'
include_recipe 'java::oracle'
package 'hive'

package 'libmysql-java'

remote_file '/usr/share/java/mysql-connector-java-5.1.26-bin.jar' do
  source "https://dl.dropboxusercontent.com/u/8130946/firenxis/mysql-connector-java-5.1.26-bin.jar"
  mode 0644
  action :create_if_missing
end

link '/usr/share/java/mysql-connector-java.jar' do
  to '/usr/share/java/mysql-connector-java-5.1.26-bin.jar'
end

link '/usr/lib/hive/lib/mysql-connector-java.jar' do
  to '/usr/share/java/mysql-connector-java.jar'
end

directory "/etc/hive/conf.cluster" do
  owner 'root'
  group 'root'
  mode 0755
end

template '/etc/hive/conf.cluster/hive-site.xml' do
  source 'hive-site.xml.erb'
  mode 0644
end

template '/etc/hive/conf.cluster/hive-exec-log4j.properties' do
  source 'hive-exec-log4j.properties'
  mode 0644
end

template '/etc/hive/conf.cluster/hive-log4j.properties' do
  source 'hive-log4j.properties'
  mode 0644
end

execute "update-alternatives --install /etc/hive/conf hive-conf /etc/hive/conf.cluster 50"
execute "update-alternatives --set hive-conf /etc/hive/conf.cluster"
