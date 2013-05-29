include_recipe "hadoop::hive"
include_recipe "mysql::server"

remote_file "/tmp/mysql-connector-java-5.1.15.tar.gz" do
  source "https://dl.dropbox.com/u/8130946/firenxis/mysql-connector-java-5.1.15.tar.gz"
  action :create_if_missing
end

execute "uncompress mysql-connector-java" do
  cwd "/tmp"
  command "sudo tar xzf mysql-connector-java-5.1.15.tar.gz; mv mysql-connector-java-5.1.15-bin.jar /usr/lib/hadoop/lib/"
  creates "/usr/lib/hadoop/lib/mysql-connector-java-5.1.15-bin.jar"
end

template "/tmp/hive_mysql" do
  source "db_setup.erb"
  mode "0644"
end

execute "user setup mysql" do
  command "sudo mysql -u root #{node[:mysql][:server_root_password].empty? ? '' : '-p' }#{node[:mysql][:server_root_password]} < /tmp/hive_mysql"
  not_if {
    `sudo mysql -u root #{node[:mysql][:server_root_password].empty? ? '' : '-p' }#{node[:mysql][:server_root_password]} mysql -e "SELECT User FROM user WHERE User='#{node[:hive][:mysql][:username]}';" | wc -l`.to_i > 0
    }
end

template "/etc/hive/conf/hive-site.xml" do
  source "hive-site-conf.erb"
  mode "644"
end
