Chef::Log.debug('Running opsworks_rubber::stop')

execute 'stop Rubber app' do
  command node[:rubber][:commands][:stop]
end
