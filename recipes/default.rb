#
# Cookbook Name:: poolse
# Recipe:: default
#
# Copyright (c) 2017 Joe Vacovsky Jr., All Rights Reserved.

directory node['poolse']['install_loc'] do
  action :create
end


if node['poolse']['file_share'] != ''
  if node['platform_family'] == 'windows'
    node.default['poolse']['sourcebin'] = node['poolse']['file_share'] + '/installers/poolse/latest/poolse.exe'

    template "#{node['poolse']['install_loc']}/config.json" do
      source 'config.json.erb'
      variables(
        endpoint: node['poolse']['endpoint'],
        polling_interval: node['poolse']['polling_interval'],
        expected_status_code: node['poolse']['expected_status_code'],
        up_count_threshold: node['poolse']['up_count_threshold'],
        down_count_threshold: node['poolse']['down_count_threshold'],
        http_port: node['poolse']['http_port'],
      )
    end

    # if a version is already present
    if File.exist?("#{node['poolse']['install_loc']}/VERSION")
      local_version = ::File.read("#{node['poolse']['install_loc']}/VERSION").chomp

      remote_version = Chef::HTTP.new(node['poolse']['file_share']).get('/installers/poolse/latest/VERSION.txt')
      puts '***********', remote_version, local_version, '***********'


      if remote_version != local_version
        puts "Remote version does not match local version.  Updating local version from remote."
        powershell_script 'kill poolse process' do
          code 'c:\windows\nssm.exe stop poolse'
          ignore_failure true
        end
        nssm 'poolse' do
          action :remove
        end

        remote_file 'VERSION' do
          source node['poolse']['file_share'] + '/installers/poolse/latest/VERSION.txt'
          path ::File.join(node['poolse']['install_loc'], 'VERSION')
          action :create
        end

        remote_file 'poolse.exe' do
          source node['poolse']['sourcebin']
          path ::File.join(node['poolse']['install_loc'], 'poolse.exe')
          action :create
        end

        nssm 'poolse' do
          program 'c:\\poolse\\poolse.exe'
          args 'c:\\poolse\\config.json'
          action :install
        end
      else
        puts "Local version matches remote version.  Skipping."
      end



    else # first time setup!
      puts "No previous installation detected.  Installing!"

      remote_file 'VERSION' do
        source node['poolse']['file_share'] + '/installers/poolse/latest/VERSION.txt'
        path ::File.join(node['poolse']['install_loc'], 'VERSION')
        action :create
      end
      
      powershell_script 'kill poolse process' do
        code 'Stop-Process -processname poolse*'
        ignore_failure true
      end

      remote_file 'poolse.exe' do
        source node['poolse']['sourcebin']
        path ::File.join(node['poolse']['install_loc'], 'poolse.exe')
        action :create
      end

      windows_task 'poolse' do
        cwd node['poolse']['install_loc']
        command 'c:\\poolse\\poolse.exe c:\\poolse\\config.json'
        run_level :limited
        frequency :onstart
      end

      windows_task 'poolse' do
        action :disable
      end
      windows_task 'poolse' do
        action :end
      end
      nssm 'poolse' do
        program 'c:\\poolse\\poolse.exe'
        args 'c:\\poolse\\config.json'
        action :install
      end
    end
  end
else # *nix installation
  node.override['poolse']['sourcebin'] = 'http://github.com/vacoj/poolse/bin/poolse'
end
