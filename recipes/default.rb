#
# Cookbook Name:: poolse
# Recipe:: default
#
# Copyright (c) 2017 Joe Vacovsky Jr., All Rights Reserved.

directory node['poolse']['install_loc'] do
  action :create
  recursive true
end

template "#{node['poolse']['install_loc']}/config.json" do
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

include_recipe 'poolse::dock'

# nssm 'poolse' do
#   program 'c:\\poolse\\poolse.exe'
#   args 'c:\\poolse\\config.json'
#   action :install
# end
