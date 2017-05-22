#
# Cookbook Name:: poolse
# Recipe:: default
#
# Copyright (c) 2017 Joe Vacovsky Jr., All Rights Reserved.
include_recipe 'yum-epel'

deps = %w(
  psmisc
  screen
  npm
  git
)

deps.each do |d|
  yum_package d do
    action :install
  end
end
npm_package 'bower'

config_path = ::File.join(node['poolse']['install_loc'], '/poolse/config.json')
local_binpath = ::File.join(node['poolse']['install_loc'], '/poolse/src/poolse/', node['poolse']['remote_bin'])
repo_binpath = ::File.join(node['poolse']['install_loc'], '/poolse/bin/', node['poolse']['remote_bin'])

execute "killing running #{node['poolse']['remote_bin']} instance" do
  command "killall #{node['poolse']['remote_bin']};"
  ignore_failure true
  action :run
end

directory node['poolse']['install_loc'] do
  action :create
  recursive true
end

execute 'clone poolse repo' do
  command "cd #{node['poolse']['install_loc']}; git clone #{node['poolse']['repo']}"
  action :run
  not_if { ::Dir.exist?(::File.join(node['poolse']['install_loc'], 'poolse')) }
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

execute 'copy poolse bin into place' do
  command "cp #{repo_binpath} #{local_binpath}"
  action :run
end

execute 'installing bower components' do
  command "cd #{::File.join(node['poolse']['install_loc'], '/poolse/src/poolse/', 'static')}; bower install --allow-root"
  action :run
end

execute 'poolse' do
  command "chmod +x #{local_binpath}"
  action :run
end

execute 'starting poolse' do
  command "cd #{::File.join(node['poolse']['install_loc'], '/poolse/src/poolse/')}; screen -S poolse -d -m #{local_binpath} #{config_path}"
  action :run
end
