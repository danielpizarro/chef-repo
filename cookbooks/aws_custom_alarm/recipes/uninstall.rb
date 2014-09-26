ash "remove CloudWatch" do
  user "root"
  cwd "/usr/share"
  code <<-EOH
  rm -Rf /usr/share/CloudWatch
  EOH
end
