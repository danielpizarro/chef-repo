#
# Check a resposonse hiven a script
#
action :create do

  user      = new_resource.user
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
  script_file                 = new_resource.script_file
  dir_file                    = new_resource.dir_file

  if(script_file.split(".").last == "erb")
    script_file   = new_resource.script_file.split(".").slice(0,2).join(".")
    response_file = new_resource.response_file.split(".").slice(0,2).join(".")

    extension_script    = script_file.split(".").pop
    extension_response  = response_file.split(".").pop
    id = new_resource.script_file_values.keys[0].to_s + "-" + new_resource.script_file_values.values[0].to_s
    script_file   = script_file   + "_" + id + "." + extension_script
    response_file = response_file + "_" + id + "." + extension_response

    template "/etc/aws-scripts-mon/custom-scripts/#{script_file}" do
      source new_resource.dir_file + new_resource.script_file
      variables new_resource.script_file_values
      mode 0740
    end
  else
    cookbook_file "/etc/aws-scripts-mon/custom-scripts/#{script_file}" do
      source new_resource.dir_file + script_file
      mode 0740
    end
  end

  cookbook_file "/etc/aws-scripts-mon/custom-scripts/#{new_resource.response_file}" do
    source new_resource.dir_file  + new_resource.response_file
    mode 0740
  end

  cron "aws_metric_#{script_file}_cron" do
    user    user
    minute  minute
    hour    hour
    day     day
    month   month
    command "/etc/aws-scripts-mon/mon-put-instance-data.pl --from-cron --aws-credential-file=/etc/aws-scripts-mon/awscreds --command-avail --command-name=#{script_file}"
    action :create
  end

  bash "Create Alarm for #{script_file}" do
    user user
    cwd "/usr/share/CloudWatch/bin"
    code <<-EOH
          export JAVA_HOME=/usr/lib/jvm/default-java
          export AWS_HOSTNAME=`hostname`
          export AWS_INSTANCE_ID=`GET #{node.default.aws.metadata.url}`
          export AWS_CLOUDWATCH_HOME=/usr/share/CloudWatch
          export AWS_CREDENTIAL_FILE=/usr/share/CloudWatch/awscreds
           
             /usr/share/CloudWatch/bin/mon-put-metric-alarm \
    			 --alarm-name CommandStatus_#{script_file}_${AWS_HOSTNAME}_${AWS_INSTANCE_ID} \
    			 --alarm-description  "#{alarm_description}" \
           --period #{metric_period} \
           --evaluation-periods #{metric_evaluation_periods}  \
    			 --metric-name CommandStatus_#{script_file} \
           --statistic #{metric_statistic} \
           --threshold #{metric_threshold} \
           --comparison-operator #{metric_comparison_operator} \
           --namespace #{metric_namespace} \
           --dimensions InstanceId=${AWS_INSTANCE_ID} \
           --unit #{metric_unit} \
           --alarm-actions #{node.aws.sns.ops} \
           --ok-actions #{node.aws.sns.ops} \
           --insufficient-data-actions #{node.aws.sns.ops}
           EOH
    end
end
