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

%w{namenode datanode jobtracker tasktracker}.each do |d|
  service "hadoop-0.20-#{d}" do
    action [ :stop ]
    ignore_failure true
  end
end

# Create dirs
# HDFS Data Dir
script "Delete & Create datadir" do
  user "root"
  interpreter "bash"
  code <<-EOH
    rm -rf #{node['hadoop']['hdfs']['data_dir']}
    mkdir -p #{node['hadoop']['hdfs']['data_dir']}
    chown -R hdfs:hadoop #{node['hadoop']['hdfs']['data_dir']}
  EOH
end
# MapRed Local Dir
script "Delete & Create local dir" do
  user "root"
  interpreter "bash"
  code <<-EOH
    rm -rf #{node['hadoop']['mapred']['local_dir']}
    mkdir -p #{node['hadoop']['mapred']['local_dir']}
    chown -R mapred:hadoop #{node['hadoop']['mapred']['local_dir']}
  EOH
end

%w{namenode datanode jobtracker tasktracker}.each do |d|
  service "hadoop-0.20-#{d}" do
    action [ :start ]
    ignore_failure true
  end
end