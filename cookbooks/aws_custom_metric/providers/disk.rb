#
# Check DISK Usage
#
action :create do

   minute    = new_resource.minute
   hour      = new_resource.hour
   day       = new_resource.day
   month     = new_resource.month

   alarm_description           = new_resource.alarm_description
   metric_period               = new_resource.metric_period
   metric_evaluation_periods   = new_resource.metric_evaluation_periods
   metric_statistic            = new_resource.metric_statistic
   metric_threshold            = new_resource.metric_threshold
   metric_namespace            = new_resource.metric_namespace
   metric_unit                 = new_resource.metric_unit
   metric_comparison_operator  = new_resource.metric_comparison_operator

   filesystem                  = new_resource.filesystem
   mount_path                  = new_resource.mount_path

   cron "aws_disk_metric_#{mount_path}" do
      user "root"
      minute minute
      hour "*"
      day "*"
      month "*"
      command "/etc/aws-scripts-mon/mon-put-instance-data.pl --from-cron --disk-space-util --disk-path=#{mount_path} --aws-credential-file=/etc/aws-scripts-mon/awscreds"
      action :create
   end

   bash "Create DiskSpace Alarm for #{mount_path} " do
      user "root"
      cwd "/usr/share/CloudWatch/bin"
      code <<-EOH
         export JAVA_HOME=/usr/lib/jvm/default-java
         export AWS_HOSTNAME=`hostname`
         export AWS_INSTANCE_ID=`GET #{node.default.aws.metadata.url}`
         export AWS_CLOUDWATCH_HOME=/usr/share/CloudWatch
         export AWS_CREDENTIAL_FILE=/usr/share/CloudWatch/awscreds

         /usr/share/CloudWatch/bin/mon-put-metric-alarm \
         --alarm-name 'DiskSpace_#{mount_path}_'${AWS_HOSTNAME}_${AWS_INSTANCE_ID} \
         --alarm-description  '#{alarm_description}' \
         --period #{metric_period} \
         --evaluation-periods #{metric_evaluation_periods}  \
         --metric-name DiskSpaceUtilization \
         --statistic #{metric_statistic} \
         --threshold #{metric_threshold} \
         --comparison-operator #{metric_comparison_operator} \
         --namespace '#{metric_namespace}' \
         --dimensions "InstanceId=${AWS_INSTANCE_ID},MountPath=#{mount_path},Filesystem=#{filesystem}" \
         --unit #{metric_unit} \
         --alarm-actions #{node.aws.sns.ops} \
         --ok-actions #{node.aws.sns.ops} \
         --insufficient-data-actions #{node.aws.sns.ops}
         EOH
   end
   
end