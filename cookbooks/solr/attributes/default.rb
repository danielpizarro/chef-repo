default[:solr][:user] = 'solr'
default[:solr][:version] = '4.0.0'
default[:solr][:source][:basename] = "apache-solr-#{node[:solr][:version]}.tgz"
default[:solr][:source][:url] = "http://dl.dropbox.com/u/8130946/inzpiral/#{node[:solr][:source][:basename]}"
default[:solr][:source][:home] = '/var/solr-standalone'
default[:solr][:instances] = [{:instance_name => 'smu', :type => :multicore}, {:instance_name => 'qobbit-daily', :type => :multicore}]
default[:solr][:min_memory] = 1024
default[:solr][:max_memory] = 2048