package 'libwww-perl'
package 'libcrypt-ssleay-perl'
package 'zip'

directory '/etc/aws-scripts-mon/' do
  owner 'root'
  group 'root'
  mode 00644
  action :create
end

directory '/etc/aws-scripts-mon/custom-scripts/' do
  owner 'root'
  group 'root'
  mode 00644
  action :create
end

cookbook_file '/etc/aws-scripts-mon/mon-get-instance-stats.pl' do
  source 'mon-get-instance-stats.pl'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/mon-put-instance-data.pl' do
  source 'mon-put-instance-data.pl'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/CloudWatchClient.pm' do
  source 'CloudWatchClient.pm'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/LICENSE.txt' do
  source 'LICENSE.txt'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/curl_check.py' do
  source 'curl_check.py'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/process_check.py' do
  source 'process_check.py'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/hadoop_hdfs_check.py' do
  source 'hadoop_hdfs_check.py'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/hive_check.py' do
  source 'hive_check.py'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/multiple_process_check.py' do
  source 'multiple_process_check.py'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/command_check.py' do
  source 'command_check.py'
  mode 0755
  owner "root"
  group "root"
end

cookbook_file '/etc/aws-scripts-mon/boto.tar.gz' do
  source 'boto.tar.gz'
  mode 0755
  owner "root"
  group "root"
end

bash "Untar boto.tar.gz" do
  user "root"
  group "root"
  flags '-l'
  code <<-EOH
      tar -zxf boto.tar.gz
      rm boto.tar.gz
  EOH
  cwd "/etc/aws-scripts-mon/"
  not_if { ::File.directory?("/etc/aws-scripts-mon/boto") }
end