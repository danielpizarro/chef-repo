directory "/home/vagrant" do
  owner "vagrant"
  group "vagrant"
  mode 0755
  action :create
end

remote_file "/tmp/redis-2.8.3.tar.gz" do
  source "http://download.redis.io/releases/redis-2.8.3.tar.gz"
  owner "vagrant"
  group "vagrant"
  action :create_if_missing
end

script "decompress redis" do
  interpreter "bash"
  user "vagrant"
  cwd "/tmp"
  code <<-EOH
  cd /home/vagrant
  tar xzf /tmp/redis-2.8.3.tar.gz
  EOH
end

bash "make redis" do
  user "vagrant"
  group "vagrant"
  code <<-EOH
  cd /home/vagrant/redis-2.8.3
  make
  EOH
  environment  ({'HOME' => "/home/vagrant"})
  flags '-l'
end
