default['hadoop']['cdh'] = 'cdh3u5'

default['hive']['mysql']['host'] = "localhost"
default['hive']['mysql']['username'] = "hiveuser"
default['hive']['mysql']['password'] = "password"

default['hive']['server']['log'] = "/var/log/hive-server.log"
default['hive']['server']['pidfile'] = "/var/run/hive-server.pid"

default['hadoop']['master']['hostname']     = 'master'
default['hadoop']['master']['hdfs_port']    = '8020'
default['hadoop']['master']['mapred_port']  = '8021'

default['hadoop']['slaves']                 = ['master', 'slave']

default['hadoop']['hdfs']['replication']  = 2
default['hadoop']['hdfs']['name_dir']     = "/var/dfs/name"
default['hadoop']['hdfs']['data_dir']     = "/var/dfs/dn"
default['hadoop']['hdfs']['format']       = false
default['hadoop']['mapred']['map_tasks_maximum']      = 1
default['hadoop']['mapred']['reduce_tasks_maximum']   = 1
default['hadoop']['mapred']['local_dir']              = "/var/mapred/local"
default['hadoop']['mapred']['system_dir']             = "/mapred/system"

default['hadoop']['conf_name'] = "conf.fx_cluster_#{Time.now.strftime("%Y%m%d_%H%M%S")}"