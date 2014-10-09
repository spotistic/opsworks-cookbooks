Chef::Log.info('Running opsworks_rubber::restart')

execute 'restart Rubber app' do
  command node[:rubber][:commands][:restart]
end
