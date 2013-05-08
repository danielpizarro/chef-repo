include_recipe 'java::oracle'

# group node[:solr][:user]

# user node[:solr][:user] do
#   gid node[:solr][:user]
#   shell '/bin/bash'
#   home "/home/#{node[:solr][:user]}"
#   supports :manage_home => true
# end

directory "/home/#{node[:solr][:user]}/tmp" do
  owner node[:solr][:user]
  group node[:solr][:user]
  mode 0755
  action :create
end

version = node[:solr][:version]
unpacked_solr_dir = "/home/#{node[:solr][:user]}/tmp/apache-solr-#{version}"
# WARNING! THIS REMOVE THE GZ COMPRESSSION
remote_file "#{unpacked_solr_dir}.tar" do
  source node[:solr][:url]
  owner node[:solr][:user]
  group node[:solr][:user]
  mode 0644
  not_if {File.exists? "#{unpacked_solr_dir}.tar"}
end

bash "unpack solr #{unpacked_solr_dir}.tar" do
  cwd "/home/#{node[:solr][:user]}/tmp"
  user node[:solr][:user]
  code "tar xf #{unpacked_solr_dir}.tar"
  not_if "test -d #{unpacked_solr_dir}"
end

solr_instance_path = "/home/#{node[:solr][:user]}/solr"
directory solr_instance_path do
  owner node[:solr][:user]
  group node[:solr][:user]
  mode 0755
  action :create
end

# Install each standalone solr
node[:solr][:instances].each do |instance|
    instance_name = instance[:instance_name]
    solr_dir = "/home/#{node[:solr][:user]}/solr"

  unless File.exists?("#{solr_dir}/#{instance_name}")
    directory "#{solr_dir}/#{instance_name}" do
      owner node[:solr][:user]
      group node[:solr][:user]
      mode 0755
      action :create
    end

    execute "cp -R #{unpacked_solr_dir}/example/* #{solr_dir}/#{instance_name}" do
      not_if {File.exists? "#{solr_dir}/#{instance_name}/example/start.jar"}
    end

    if instance[:type] == :multicore
      directory "#{solr_dir}/#{instance_name}/multicore/template_core/conf" do
        recursive true
      end

      cookbook_file "#{solr_dir}/#{instance_name}/multicore/template_core/conf/solrconfig.xml" do
        source 'solrconfig.xml'
      end

      cookbook_file "#{solr_dir}/#{instance_name}/multicore/template_core/conf/schema.xml" do
        source 'schema.xml'
      end

      cookbook_file "#{solr_dir}/#{instance_name}/multicore/solr.xml" do
        source 'solr.xml'
        not_if "grep '<!-- chef-cookbook-file -->' #{solr_dir}/#{instance_name}/multicore/solr.xml"
      end
    end

    execute "chown -R #{node[:solr][:user]}:#{node[:solr][:user]} #{solr_dir}"
  end
end
