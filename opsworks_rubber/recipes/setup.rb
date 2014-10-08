# setup rubber service
Chef::Log.debug('Running opsworks_rubber::setup')

application = 'rubber'
deploy = node[:deploy][application]
return if !deploy

opsworks_deploy_user do
  deploy_data deploy
end

opsworks_deploy_dir do
  user deploy[:user]
  group deploy[:group]
  path deploy[:deploy_to]
end

# Allow deploy user to use `upstart`
template "/etc/sudoers.d/#{deploy[:user]}" do
  mode 0440
  source 'sudoer.erb'
  variables :user => deploy[:user]
end

# Create env var file
template File.join(deploy[:deploy_to], 'shared', 'app.env') do
  source 'app.env.erb'
  mode 0770
  owner deploy[:user]
  group deploy[:group]
  variables(
    :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
  )
  only_if { File.exists?("#{deploy[:deploy_to]}/shared") }
end

config = node[:rubber][:config].to_hash
config_directory = "#{deploy[:deploy_to]}/shared/config"

# Convert attribute classes to plain old ruby objects
config.each do |k, v|
  case v
  when Chef::Node::ImmutableArray
    config[k] = v.to_a
  when Chef::Node::ImmutableMash
    config[k] = v.to_hash
  end
end

# Generate YAML string
yaml = YAML::dump(config)

# Convert YAML string keys to symbol keys for sidekiq while preserving
# indentation. (queues: to :queues:)
yaml = yaml.gsub(/^(\s*)([^:][^\s]*):/,'\1:\2:')

file "#{config_directory}/#{application}.yml" do
  mode 0644
  action :create
  content yaml
end

template '/etc/init/sidekiq.conf' do
  mode 0644
  source 'sidekiq.conf.erb'
  variables({
    :deploy => deploy,
    :conf_file => "#{deploy[:deploy_to]}/shared/config/#{application}.yml",
    :require_file => "#{deploy[:current_path]}/lib/rubber.rb"
  })
end

template "/etc/init/#{application}.conf" do
  mode 0644
  source "#{application}.conf.erb"
  variables :cpus => node[:cpu][:total]
end
