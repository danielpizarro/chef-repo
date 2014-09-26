disks = `mount | grep -E '/dev/sd|/dev/xvd' | awk '{print $1, $3}'`.split("\n")
disks.each do |device_id|

	filesystem = device_id.split(' ')[0]
	mount_path = device_id.split(' ')[1]

	aws_custom_metric_disk "Create DiskSpace Alarm for #{mount_path}" do
	  filesystem  filesystem
	  mount_path  mount_path

	  minute            "*/5"
	  alarm_description "DiskSpace Utilization Problem"
	  metric_threshold  "90"
	  metric_comparison_operator "GreaterThanThreshold"
	  metric_unit                "Percent"
	end
end

