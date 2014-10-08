Chef::Log.debug('Running opsworks_rubber::start')

execute 'start Rubber app' do
  command node[:rubber][:commands][:start]
end
