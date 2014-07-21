action :create do

   minute    = new_resource.minute

   alarm_description           = new_resource.alarm_description
   metric_period               = new_resource.metric_period
   metric_evaluation_periods   = new_resource.metric_evaluation_periods
   metric_statistic            = new_resource.metric_statistic
   metric_threshold            = new_resource.metric_threshold
   metric_namespace            = new_resource.metric_namespace
   metric_unit                 = new_resource.metric_unit
   metric_comparison_operator  = new_resource.metric_comparison_operator

   cron "aws_mem_swap_metric" do
      user "root"
      minute minute
      hour "*"
      day "*"
      month "*"
      command "/etc/aws-scripts-mon/mon-put-instance-data.pl --from-cron --mem-util --swap-util --aws-credential-file=/etc/aws-scripts-mon/awscreds"
      action :create
   end
   
   bash "Create Memory and Swap Alarms " do
      user "root"
      cwd "/usr/share/CloudWatch/bin"
      code <<-EOH
			export JAVA_HOME=/usr/lib/jvm/default-java
			export AWS_HOSTNAME=`hostname`
			export AWS_INSTANCE_ID=`GET #{node.default.aws.metadata.url}`
			export AWS_CLOUDWATCH_HOME=/usr/share/CloudWatch
			export AWS_CREDENTIAL_FILE=/usr/share/CloudWatch/awscreds

			 /usr/share/CloudWatch/bin/mon-put-metric-alarm \
			 --alarm-name 'SwapUtilization_'${AWS_HOSTNAME}_${AWS_INSTANCE_ID} \
			 --alarm-description  '#{alarm_description}' \
			 --period #{metric_period} \
			 --evaluation-periods #{metric_evaluation_periods}  \
			 --metric-name SwapUtilization \
			 --statistic #{metric_statistic} \
			 --threshold #{metric_threshold} \
			 --comparison-operator #{metric_comparison_operator} \
			 --namespace '#{metric_namespace}' \
			 --dimensions "InstanceId=${AWS_INSTANCE_ID}" \
			 --unit #{metric_unit} \
			 --alarm-actions #{node.aws.sns.ops} \
			 --ok-actions #{node.aws.sns.ops} \
			 --insufficient-data-actions #{node.aws.sns.ops}
		EOH
   end
end