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

include_recipe "hadoop"

package "hadoop-0.20-conf-pseudo" do
  options "--force-yes" if platform?("ubuntu")
end

%w{namenode secondarynamenode datanode jobtracker tasktracker}.each do |d|
  service "hadoop-0.20-#{d}" do
    action [ :stop, :start, :enable ]
  end
end
