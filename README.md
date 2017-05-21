
# poolse cookbook

### Installs <a href="https://github.com/vacoj/poolse">Poolse</a> (https://github.com/vacoj/poolse), a healthcheck hashboard for http endpoints.

After successful run of the cookbook, poolse will be available on the default port of 5704, unless changed in the attributes.rb file.

#### Attributes

``` ruby

# an array of target endpoints for monitoring.  See poolse documentation for further options.
default['poolse']['targets'] = [
  {
    endpoint: 'http://poolse.vacovsky.us/',
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

# custom settings for poolse.  "http_port" is the port poolse web interface will be exposed.
default['poolse']['settings'] = {
  http_port: '5704',
  debug: false,
  show_http_log: false,
  state_file_name: 'state.dat',
  persist_state: true,
  startup_state: true
}

# name of binary to use from within the poolse repository.  This will be an auto-detected field when I get around to it
default['poolse']['remote_bin'] = 'poolse_x64'

# repository hosting the poolse code
default['poolse']['repo'] = 'https://github.com/vacoj/poolse.git'

# root direcotry to clone the poolse source into.
default['poolse']['install_loc'] = '/opt/'

```


#### Tested with:
- docker centos image
- vagrant centos/7 image

Poolse can be found here: <a href="https://github.com/vacoj/poolse">Poolse (https://github.com/vacoj/poolse)</a>
