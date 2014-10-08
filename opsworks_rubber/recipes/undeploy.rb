Chef::Log.debug('Running opsworks_rubber::undeploy')
include_recipe 'deploy'

application = 'rubber'
include_recipe 'deploy'
deploy = node[:deploy][application]
return if !deploy

directory deploy[:deploy_to] do
  recursive true
  action :delete
  only_if do
    File.exists?(deploy[:deploy_to])
  end
end
