action :setup do
  home_path = @new_resource.name
  install_path = @new_resource.identifier.nil? ? home_path : ::File.join(home_path, @new_resource.identifier)
  Chef::Log.info("Checking path for older installation")
  if exists?
    Chef::Log.info("Solr instance already installed in #{install_path}")
  else
    Chef::Log.info("Solr instance not found in #{install_path}. Installing...")
    packed_solr_source = ::File.join(Chef::Config[:file_cache_path], node[:solr][:source][:basename])
    remote_file packed_solr_source do
      source node[:solr][:source][:url]
      action :create_if_missing
    end
    # TODO: check why this have to run twice to get a gzip file instead a regular file
    remote_file packed_solr_source do
      source node[:solr][:source][:url]
      action :create_if_missing
    end
    bash "Extract solr source to #{install_path}" do
      cwd ::File.dirname(packed_solr_source)
      code <<-EOH
        mkdir -p #{install_path}
        tar xzf #{node[:solr][:source][:basename]} -C #{install_path}
        mv #{install_path}/*/* #{install_path}/
      EOH
      not_if {::File.exists?(install_path)}
    end
  end
  if @new_resource.multicore
    multicore_path = ::File.join install_path, 'example', 'multicore'
    Chef::Log.info("Configuring multicore...")
    template_conf_path = ::File.join(multicore_path, 'template', 'conf')
    directory template_conf_path do
      recursive true
    end

    cookbook_file ::File.join(template_conf_path, 'solrconfig.xml') do
      cookbook 'solr'
      source 'solrconfig.xml'
    end

    cookbook_file ::File.join(template_conf_path, 'schema.xml') do
      cookbook 'solr'
      source 'schema.xml'
    end

    solr_xml_path = ::File.join(multicore_path, 'solr.xml')
    cookbook_file solr_xml_path do
      cookbook 'solr'
      source 'solr.xml'
      not_if "grep '<!-- chef-cookbook-file -->' #{solr_xml_path}"
    end
  end

  owner = @new_resource.owner
  unless @new_resource.system_wide

    bootstrap_rc owner do
      user owner
      action :setup
    end

    bash "Changing owner, group and mode to #{home_path}" do
      code <<-EOH
        chown -R #{owner}:#{owner} #{home_path}
        chmod -R 755 #{home_path}
      EOH
    end
  end

  unless @new_resource.data_dir.nil?
    directory @new_resource.data_dir do
      unless owner.nil?
        user owner
        group owner
      end
      recursive true
    end
    directory ::File.join(@new_resource.data_dir, @new_resource.stop_key) do
      unless owner.nil?
        user owner
        group owner
      end
      recursive true
    end
  end

  jetty_conf = "-Djetty.port=#{@new_resource.port} -Djetty.home=#{install_path}/example"
  stop_key = @new_resource.stop_key
  stop_conf = "-DSTOP.PORT=#{@new_resource.stop_port} -DSTOP.KEY=#{stop_key}"
  data_conf = @new_resource.data_dir.nil? ? nil : "-Dsolr.data.dir=#{::File.join(@new_resource.data_dir, @new_resource.stop_key)}"
  multicore_conf = @new_resource.multicore ? "-Dsolr.solr.home=#{install_path}/example/multicore" : "-Dsolr.solr.home=#{install_path}/example/solr"
  jar_conf = "-jar #{install_path}/example/start.jar"
  java_conf = 'java'
  command = [java_conf, stop_conf, multicore_conf, jetty_conf, data_conf, jar_conf].compact.join(' ')

  template "#{install_path}/example/wrapper.sh" do
    source 'wrapper.sh.erb'
    mode 0755
    owner owner
    group owner
    cookbook 'solr'
    variables :command => command, :pidfilename => stop_key
  end

  monitrc stop_key do
    action :enable
    reload :delayed
    variables :script => "#{install_path}/example/wrapper.sh", :pidfilename => stop_key
    template_cookbook 'solr'
    template_source 'monit.conf.erb'
  end
end

private
def exists?
  ::File.exist?(@new_resource.name) && ::File.directory?(@new_resource.name)
end
