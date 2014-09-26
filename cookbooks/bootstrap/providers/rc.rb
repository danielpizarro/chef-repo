action :setup do

  group new_resource.user

  package('build-essential').run_action(:install)
  if platform?('ubuntu')
    case node.platform_version
    when "10.04", "12.04"
      package 'libshadow-ruby1.8'
    when "14.04"
    end
  end
  chef_gem 'ruby-shadow'
  user new_resource.user do
    password `openssl passwd -1 "#{new_resource.user}"`.strip
    gid new_resource.user
    home "/home/#{new_resource.user}"
    supports :manage_home => true
    shell '/bin/bash'
  end

  cookbook_file "/home/#{new_resource.user}/.gemrc" do
    cookbook 'bootstrap'
    source 'gemrc'
    owner new_resource.user
    group new_resource.user
    mode 0644
  end

  cookbook_file "/home/#{new_resource.user}/.irbrc" do
    cookbook 'bootstrap'
    source 'irbrc'
    owner new_resource.user
    group new_resource.user
    mode 0644
  end

  cookbook_file "/home/#{new_resource.user}/.gitconfig" do
    cookbook 'bootstrap'
    source 'gitconfig'
    owner new_resource.user
    group new_resource.user
    mode 0644
  end
end
