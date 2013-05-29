action :setup do
  home_path = @new_resource.home
  install_path = @new_resource.identifier.nil? ? home_path : ::File.join(home_path, @new_resource.identifier)
  Chef::Log.info("@new_resource.version:#{@new_resource.version}")
  solr_source_basename = "apache-solr-#{@new_resource.version || '4.0.0'}.tgz"
  solr_source_url = ::File.join(node[:solr][:source][:base_url], solr_source_basename)
  Chef::Log.info("Checking path for older installation")
  if exists? install_path
    Chef::Log.info("Solr instance already installed in #{install_path}")
  else
    Chef::Log.info("Solr instance not found in #{install_path}. Installing...")
    packed_solr_source = ::File.join(Chef::Config[:file_cache_path], solr_source_basename)
    remote_file packed_solr_source do
      source solr_source_url
      action :create_if_missing
    end
    # TODO: check why this have to run twice to get a gzip file instead a regular file
    remote_file packed_solr_source do
      source solr_source_url
      action :create_if_missing
    end
    bash "Extract solr source to #{install_path}" do
      cwd ::File.dirname(packed_solr_source)
      code <<-EOH
        mkdir -p #{install_path}
        tar xzf #{solr_source_basename} -C #{install_path}
        mv #{install_path}/*/* #{install_path}/
      EOH
      not_if {::File.exists?(install_path)}
    end
  end
  if @new_resource.version >= '4.0.0'
    template ::File.join(install_path, 'example', 'contexts', 'solr.xml') do
      cookbook 'solr'
      source 'contexts_solr.xml.erb'
      variables :tmp_base_dir => ::File.join(install_path, 'example')
    end
  else
    directory @new_resource.home
  end

  if @new_resource.multicore
    multicore_path = ::File.join(install_path, 'example', 'multicore')
    Chef::Log.info("Configuring multicore...")
    template_conf_path = ::File.join(multicore_path, 'template', 'conf')
    directory template_conf_path do
      recursive true
    end

    core_template_cookbook = @new_resource.core_template_cookbook

    cookbook_file ::File.join(template_conf_path, 'solrconfig.xml') do
      cookbook core_template_cookbook || 'solr'
      source 'solrconfig.xml'
    end

    cookbook_file ::File.join(template_conf_path, 'schema.xml') do
      cookbook core_template_cookbook || 'solr'
      source 'schema.xml'
    end

    solr_xml_path = ::File.join(multicore_path, 'solr.xml')
    cookbook_file solr_xml_path do
      cookbook core_template_cookbook || 'solr'
      source 'solr.xml'
      persistent = '<solr persistent="true">'
      not_if "grep '#{persistent}' #{solr_xml_path}"
    end

    cookbook_file ::File.join(template_conf_path, 'admin-extra.html') do
      cookbook 'solr'
      source 'admin-extra.html'
    end

    cookbook_file ::File.join(template_conf_path, 'admin-extra.menu-bottom.html') do
      cookbook 'solr'
      source 'admin-extra.menu-bottom.html'
    end

    cookbook_file ::File.join(template_conf_path, 'admin-extra.menu-top.html') do
      cookbook 'solr'
      source 'admin-extra.menu-top.html'
    end
  end

  unless @new_resource.data_dir.nil?
    directory ::File.join(@new_resource.data_dir, @new_resource.stop_key) do
      recursive true
    end
  end

  jetty_conf = "-Djetty.port=#{@new_resource.port} -Djetty.home=#{install_path}/example"
  stop_key = @new_resource.stop_key
  stop_conf = "-DSTOP.PORT=#{@new_resource.stop_port} -DSTOP.KEY=#{stop_key}"
  data_conf = @new_resource.data_dir.nil? ? nil : "-Dsolr.data.dir=#{::File.join(@new_resource.data_dir, @new_resource.stop_key)}"
  multicore_conf = @new_resource.multicore ? "-Dsolr.solr.home=#{install_path}/example/multicore" : "-Dsolr.solr.home=#{install_path}/example/solr"
  newrelic_conf = nil
  unless @new_resource.newrelic_jar_url.nil?
    newrelic_jar_url = @new_resource.newrelic_jar_url
    remote_file ::File.join(install_path, 'example', 'newrelic.jar') do
      source newrelic_jar_url
      action :create_if_missing
    end
    newrelic_template_cookbook = @new_resource.newrelic_template_cookbook
    template ::File.join(install_path, 'example', 'newrelic.yml') do
      source 'newrelic.yml.erb'
      cookbook newrelic_template_cookbook
      variables :app_name => stop_key
    end
    newrelic_conf = "-javaagent:#{::File.join(install_path, 'example', 'newrelic.jar')}"
  end
  jar_conf = "-jar #{install_path}/example/start.jar"
  java_conf = 'java'
  command =  [java_conf, stop_conf, multicore_conf, jetty_conf, data_conf, newrelic_conf, jar_conf].compact.join(' ')


  template "#{install_path}/example/wrapper.sh" do
    source 'wrapper.sh.erb'
    mode 0755
    cookbook 'solr'
    variables :command => command, :pidfilename => stop_key, :cwd => ::File.join(install_path, 'example')
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
def exists?(install_path)
  ::File.exist?(install_path) && ::File.directory?(install_path)
end
