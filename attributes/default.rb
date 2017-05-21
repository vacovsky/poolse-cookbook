default['poolse']['targets'] = [
  {
    endpoint: "http://poolse.vacovsky.us:5704/",
    polling_interval: 10,
    expected_status_code: 200,
    up_count_threshold: 5,
    down_count_threshold: 1
  },
  {
    endpoint: 'http://google.com/',
    polling_interval: 10,
    expected_status_code: 301,
    up_count_threshold: 5,
    down_count_threshold: 1
  }
]

default['poolse']['settings'] = {
  http_port: '5704',
  debug: false,
  show_http_log: false,
  state_file_name: 'state.dat',
  persist_state: true,
  startup_state: true
}

default['poolse']['remote_bin'] = 'https://github.com/vacoj/poolse/raw/master/bin/poolse_x64'
default['poolse']['install_loc'] = '/opt/poolse/'

default['sshd']['sshd_config']['Port'] = 2222

# TODO: switch case for platform and architecture
# if windows
# default['poolse']['source'] = 'https://github.com/vacoj/poolse/bin/poolse.exe'
# else
# default['poolse']['source'] = 'https://github.com/vacoj/poolse/bin/poolse'
