remote_file '/tmp/parallel-20140422.tar.bz2' do
  source 'http://gnu.mirror.iweb.com/parallel/parallel-20140422.tar.bz2'
  mode 0644
  action :create_if_missing
end

bash "install parallel" do
  code <<-EOF
    cd /tmp
    tar -xjvf /tmp/parallel-20140422.tar.bz2
    cd  /tmp/parallel-20140422
    (wget -O - pi.dk/3 || curl pi.dk/3/ || fetch -o - http://pi.dk/3) | bash
  EOF
end
