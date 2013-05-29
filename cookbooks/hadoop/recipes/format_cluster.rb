#
# Cookbook Name:: hadoop
# Recipe:: conf_pseudo 
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Hay que hacer override de este valor en el DNA si de verdad se desea formatear
if node['hadoop']['hdfs']['format']

  number_of_dirs = node['hadoop']['hdfs']['name_dir'].split(",").length
  execute "echo '#{"Y"*number_of_dirs}' | sudo -u hdfs hadoop namenode -format" do
    user "root"
  end

  %w{namenode}.each do |d|
    service "hadoop-0.20-#{d}" do
      action [ :start ]
    end
  end

  if node['hadoop']['hdfs']['format']
    script "Create MapRed  HDFS dir" do
      user "root"
      interpreter "bash"
      code <<-EOH
        sudo -u hdfs hadoop fs -mkdir #{node['hadoop']['mapred']['system_dir']}
        sudo -u hdfs hadoop fs -chown mapred:hadoop #{node['hadoop']['mapred']['system_dir']}
      EOH
    end
  end

end