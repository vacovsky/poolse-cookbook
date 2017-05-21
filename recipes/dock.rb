# docker_container 'poolse' do
#   port '5704:5704'
#   host 'tcp://weirdscience:2375'
# end


# Base Setup for sshd
include_recipe 'sshd'

# Allow SSH
# firewall_rule 'ssh special port enable' do
#   firewall_name 'poolse'
#   protocol  :tcp
#   port      node['sshd']['sshd_config']['Port']
#   command   :allow
#   action    :create
# end