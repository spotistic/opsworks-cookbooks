# Adapted from nginx::stop: https://github.com/aws/opsworks-cookbooks/blob/master/nginx/recipes/stop.rb

include_recipe "opsworks_sidekiq::service"

node[:deploy].each do |application, deploy|

  execute "stop Rails app #{application}" do
    command node[:sidekiq][application][:restart_command]
  end

end
