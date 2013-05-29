#
# Cookbook Name:: hadoop
# Recipe:: default
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

include_recipe "java::oracle"

if platform?("ubuntu", "debian")

  execute "apt-get update" do
    action :nothing
  end

  template "/etc/apt/sources.list.d/cloudera.list" do
    owner "root"
    mode "0644"
    source "cloudera.list.erb"
  end

  package 'curl'
  execute "curl -s http://archive.cloudera.com/debian/archive.key | apt-key add -" do
    notifies :run, resources("execute[apt-get update]"), :immediately
  end

end

if platform?("redhat")

  remote_file "/etc/yum.repos.d/cloudera.repo" do
    source "http://archive.cloudera.com/redhat/cdh/cloudera-#{node.hadoop.cdh}.repo"
    mode "644"
    action :create_if_missing
  end

  sleep 10

  package "yum" do
    action :upgrade
  end
end

package "hadoop-0.20" do
  options "--force-yes" if platform?("ubuntu")
end
