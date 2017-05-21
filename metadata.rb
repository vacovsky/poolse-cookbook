name 'poolse'
maintainer 'Joe Vacovsky Jr.'
maintainer_email 'vacovsky@gmail.com'
license 'all_rights'
description 'Installs/Configures poolse'
long_description 'Installs/Configures poolse'
version '0.1.0'

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Issues` link
issues_url 'https://github.com/vacoj/poolse-coolbook/issues' if respond_to?(:issues_url)

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Source` link
source_url 'https://github.com/vacoj/poolse-coolbook' if respond_to?(:source_url)

depends 'windows'
depends 'nssm'
depends 'docker', '~> 2.0'
