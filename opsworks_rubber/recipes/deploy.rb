Chef::Log.info('Running opsworks_rubber::deploy')

application = 'rubber'
include_recipe 'deploy'
deploy = node[:deploy][application]
return if !deploy

opsworks_deploy_dir do
  user deploy[:user]
  group deploy[:group]
  path deploy[:deploy_to]
end

Chef::Log.info('Deploying Rubber Application')
opsworks_deploy do
  deploy_data deploy
  app application
end

if File.exists?("#{deploy[:current_path]}/Gemfile")
  Chef::Log.info("Gemfile detected. Running bundle install.")
  cmd = "sudo su - #{deploy[:user]} -c 'cd #{deploy[:current_path]} && /usr/local/bin/bundle install --path #{deploy[:home]}/.bundler/#{application} --without=#{deploy[:ignore_bundler_groups].join(' ')}'"
  Chef::Log.info(cmd)
  Chef::Log.info(OpsWorks::ShellOut.shellout("#{cmd} 2>&1"))
end

Chef::Log.info('Restarting Rubber Application')
execute 'restart Rubber app' do
  command node[:rubber][:commands][:restart]
end
