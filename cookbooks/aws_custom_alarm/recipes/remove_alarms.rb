cookbook_file '/usr/share/CloudWatch/remove_alarms.py' do
  source 'remove_alarms.py'
  mode 0755
  owner "root"
  group "root"
end

bash "Delte All Alarms" do
  user "root"
  code <<-EOH
export JAVA_HOME=/usr/lib/jvm/default-java
export AWS_HOSTNAME=`hostname`
export AWS_INSTANCE_ID=`GET #{node.default.aws.metadata.url}`
export AWS_CLOUDWATCH_HOME=/usr/share/CloudWatch
export AWS_CREDENTIAL_FILE=/usr/share/CloudWatch/awscreds
/usr/bin/python /usr/share/CloudWatch/remove_alarms.py --hostname ${AWS_HOSTNAME} --instance ${AWS_INSTANCE_ID}
  EOH
end