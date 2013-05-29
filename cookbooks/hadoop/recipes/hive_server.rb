include_recipe 'hadoop::hive_mysql'

package 'hadoop-hive-server'

service 'hadoop-hive-server' do
  enabled true
  supports [ :start, :stop, :restart, :status ]
  action :nothing
end
