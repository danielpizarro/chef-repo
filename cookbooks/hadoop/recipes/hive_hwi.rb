include_recipe "hadoop::hive_mysql"

if platform?("ubuntu", "debian")
  
  runit_service "hive-hwi"
  
elsif platform?("redhat")

  service "hive-hwi" do
    enabled true
    supports [ :start, :stop, :restart, :status ]
    action :nothing
  end
  
  template "/etc/init.d/hive-hwi" do
    mode "755"
    source "hive-hwi.erb"
    notifies :start, resources(:service => "hive-hwi")
  end
  
  execute "chkconfig --add hive-hwi" do
    not_if "chkconfig --list hive-hwi"
  end
  
  execute "chkconfig hive-hwi on"

end