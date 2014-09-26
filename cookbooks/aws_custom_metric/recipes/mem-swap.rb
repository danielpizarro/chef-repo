aws_custom_metric_memory "Create memory alarm" do
   alarm_description          "MemoryUtilization is more than 99% in 5 minutes"
   metric_threshold           "99"
   metric_comparison_operator "GreaterThanThreshold"
   metric_unit                "Percent"
end

aws_custom_metric_swap "Create swap alarm" do
   alarm_description          "SwapUtilization is more than 40% in 5 minutes"
   metric_threshold           "40"
   metric_comparison_operator "GreaterThanThreshold"
   metric_unit                "Percent"
end