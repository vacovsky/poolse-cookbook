#
# Cookbook Name:: poolse
# Recipe:: default
#
# Copyright (c) 2017 Joe Vacovsky Jr., All Rights Reserved.

config_path = ::File.join(node['poolse']['install_loc'], 'config.json')
local_binpath = ::File.join(node['poolse']['install_loc'], node['poolse']['remote_bin'].split('/').last)

directory node['poolse']['install_loc'] do
  action :create
  recursive true
end

template config_path do
  source 'config.json.erb'
  variables(
    targets: node['poolse']['targets'],
    http_port: node['poolse']['settings']['http_port'],
    debug: node['poolse']['settings']['debug'],
    show_http_log: node['poolse']['settings']['show_http_log'],
    persist_state: node['poolse']['settings']['persist_state'],
    startup_state: node['poolse']['settings']['startup_state'],
    state_file_name: node['poolse']['settings']['state_file_name']
  )
end

puts node['poolse']['remote_bin'].split('/').last
remote_file node['poolse']['remote_bin'] do
  source node['poolse']['remote_bin']
  path ::File.join(node['poolse']['install_loc'], node['poolse']['remote_bin'].split('/').last)
  action :create
end

puts "******************** #{local_binpath} #{config_path} & ********************"

execute 'poolse' do
  command "#{local_binpath} #{config_path} &"
  action :run
end



# Allow Poolse
firewall 'poolse'
firewall_rule 'Poolse port enable' do
  firewall_name 'poolse'
  protocol  :tcp
  port      node['poolse']['settings']['http_port'].to_i
  command   :allow
  action    :create
end

include_recipe 'poolse::dock'

# case node['platform']
# when 'centos', 'redhat', 'fedora'
#   service_name 'redhat_name'
# when 'windows'
#   nssm 'poolse' do
#     program 'c:\\poolse\\poolse.exe'
#     args 'c:\\poolse\\config.json'
#     action :install
#     end
# else
#   puts 'unsupported platform'
# end

# end

# #
