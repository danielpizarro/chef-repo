include_recipe 'java::oracle'

directory '/usr/share/CloudWatch/' do
  owner 'root'
  group 'root'
  mode 00644
  action :create
end

cookbook_file '/usr/share/CloudWatch/CloudWatch-1.0.13.4.tar.gz' do
  source 'CloudWatch-1.0.13.4.tar.gz'
  mode 0755
  owner "root"
  group "root"
end

bash "upgrade env" do
  user "root"
  cwd "/usr/share/CloudWatch"
  code <<-EOH
  cd /usr/share/CloudWatch
  tar -zxvf CloudWatch-1.0.13.4.tar.gz
  EOH
end

