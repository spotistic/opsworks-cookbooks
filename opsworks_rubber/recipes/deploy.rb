Chef::Log.debug('Running opsworks_rubber::deploy')

application = 'rubber'
include_recipe 'deploy'
deploy = node[:deploy][application]
return if !deploy

opsworks_deploy_dir do
  user deploy[:user]
  group deploy[:group]
  path deploy[:deploy_to]
end

Chef::Log.debug('Deploying Rubber Application')
opsworks_deploy do
  deploy_data deploy
  app application
end

if File.exists?("#{deploy[:deploy_to]}/Gemfile")
  Chef::Log.info("Gemfile detected. Running bundle install.")
  Chef::Log.info("sudo su - #{deploy[:user]} -c 'cd #{deploy[:deploy_to]} && /usr/local/bin/bundle install --path #{deploy[:home]}/.bundler/#{application} --without=#{deploy[:ignore_bundler_groups].join(' ')}'")
  Chef::Log.info(OpsWorks::ShellOut.shellout("sudo su - #{deploy[:user]} -c 'cd #{deploy[:deploy_to]} && /usr/local/bin/bundle install --path #{deploy[:home]}/.bundler/#{application} --without=#{deploy[:ignore_bundler_groups].join(' ')}' 2>&1"))
end

Chef::Log.debug('Restarting Rubber Application')
execute 'restart Rubber app' do
  command node[:rubber][:commands][:restart]
end
