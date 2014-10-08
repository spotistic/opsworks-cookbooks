name   'opsworks_rubber'
maintainer       'Maxence Decrosse'
maintainer_email 'maxence@spotistic.com'
license          'MIT'
description      'Configure and deploy rubber on opsworks with upstart.'

depends 'deploy'
depends 'ruby'

recipe 'opsworks_rubber::setup',     'Set up rubber worker.'
recipe 'opsworks_rubber::configure', 'Configure rubber worker.'
recipe 'opsworks_rubber::deploy',    'Deploy rubber worker.'
recipe 'opsworks_rubber::undeploy',  'Undeploy rubber worker.'
recipe 'opsworks_rubber::stop',      'Stop rubber worker.'
