Chef::Log.debug('Running opsworks_rubber::restart')

execute 'restart Rubber app' do
  command node[:rubber][:commands][:restart]
end
