package "wkhtmltopdf" do
  action :purge
end

%w{openssl build-essential xorg libssl-dev}.each do |p|
  package p
end

directory "/opt/wkhtmltopdf"
bash "install wkhtmltopdf" do
  not_if "ls /usr/bin/wkhtmltopdf"
  cwd "/opt/wkhtmltopdf"
  code <<-BASHCODE
    wget http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-static-#{node.source.arch}.tar.bz2
    tar xvjf wkhtmltopdf-0.9.9-static-#{node.source.arch}.tar.bz2
    chown root:root wkhtmltopdf-#{node.source.arch}
    sudo ln -s /opt/wkhtmltopdf/wkhtmltopdf-#{node.source.arch} /usr/bin/wkhtmltopdf
  BASHCODE
end
