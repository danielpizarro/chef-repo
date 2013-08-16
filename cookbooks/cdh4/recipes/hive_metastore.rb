#
# Cookbook Name:: cdh4
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'cdh4::hive'

package 'hive-metastore'

node.set_unless['mysql']['server_debian_password'] = 'root123'
node.set_unless['mysql']['server_root_password']   = 'root123'
node.set_unless['mysql']['server_repl_password']   = 'root123'
include_recipe 'mysql::server'

mysql_execute 'create hive metastore' do
  command <<-SQL
    CREATE DATABASE IF NOT EXISTS #{node.hive.metastore.db};
    USE #{node.hive.metastore.db};
    SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.10.0.mysql.sql;
  SQL
  action :run
end

mysql_execute "grant privileges to hive metastore user" do
  command <<-SQL
    DROP USER '#{node.hive.metastore.user}'@'#{node.hive.metastore.host}';
    FLUSH PRIVILEGES;
    CREATE USER '#{node.hive.metastore.user}'@'#{node.hive.metastore.host}' IDENTIFIED BY '#{node.hive.metastore.password}';
    REVOKE ALL PRIVILEGES, GRANT OPTION FROM '#{node.hive.metastore.user}'@'#{node.hive.metastore.host}';
    GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES,EXECUTE ON #{node.hive.metastore.db}.* TO '#{node.hive.metastore.user}'@'#{node.hive.metastore.host}';
    FLUSH PRIVILEGES;
  SQL
  action :run
  # not_if "mysql -uroot -proot123 -e \"select * from mysql.user where user='hive' and host='master.firenxis.com'\""
end

execute "sudo -u hdfs hadoop fs -mkdir -p /user/hive"
execute "sudo -u hdfs hadoop fs -chown hive /user/hive"

