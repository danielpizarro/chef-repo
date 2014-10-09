include_recipe 'cdh4'

package 'hadoop-client'
package 'hadoop-0.20-conf-pseudo'

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

link "/usr/lib/hadoop/hadoop-streaming-2.0.0-mr1-#{node.cdh4.dist}.jar" do
  to "/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-#{node.cdh4.dist}.jar"
end

service 'hadoop-0.20-mapreduce-jobtracker' do
  action [:enable, :start]
end

services = ['hadoop-0.20-mapreduce-tasktracker', 'hadoop-hdfs-datanode']

services.each do |daemon|
  package daemon do
    options "--force-yes"
  end
end

services.each do |daemon|
  service daemon do
    action [:enable, :start]
  end
end
