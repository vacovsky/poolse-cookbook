default['poolse']['targets'] = {
  polling_interval: 10,
  expected_status_code: 200,
  up_count_threshold: 5,
  down_count_threshold: 1
}

default['poolse']['settings'] = {
  http_port: '5704'
}

# TODO: switch case for platform and architecture
# if windows
# default['poolse']['source'] = 'https://github.com/vacoj/poolse/bin/poolse.exe'
# else
# default['poolse']['source'] = 'https://github.com/vacoj/poolse/bin/poolse'
