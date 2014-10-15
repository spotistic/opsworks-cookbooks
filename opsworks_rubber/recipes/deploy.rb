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

opsworks_deploy do
  deploy_data deploy
  app application
end

bash 'bundle_install' do
  user deploy[:user]
  cwd deploy[:current_path]
  code <<-EOH
    /usr/local/bin/bundle install --path #{deploy[:home]}/.bundler/#{application} --without=#{deploy[:ignore_bundler_groups].join(' ')}
  EOH
  only_if { File.exists?("#{deploy[:current_path]}/Gemfile") }
end

execute 'restart Rubber app' do
  command node[:rubber][:commands][:restart]
end
