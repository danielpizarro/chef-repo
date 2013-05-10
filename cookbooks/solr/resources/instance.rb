actions :setup

attribute :identifier, :kind_of => String
attribute :port, :kind_of => Integer
attribute :stop_port, :kind_of => Integer
attribute :stop_key, :kind_of => String
attribute :owner, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => 'root'
attribute :system_wide, :kind_of => [TrueClass, FalseClass], :default => false
attribute :data_dir, :kind_of => String
attribute :multicore, :kind_of => [TrueClass, FalseClass]
attribute :newrelic_jar_url, :kind_of => String
attribute :newrelic_template_cookbook, :kind_of => String
