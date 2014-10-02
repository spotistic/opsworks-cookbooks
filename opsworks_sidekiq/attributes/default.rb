include_attribute 'deploy'

default[:sidekiq] = {}

node[:deploy].each do |application, deploy|
  default[:sidekiq][application.intern] = {}
  # Apologies for the `sleep`, but monit errors with "Other action already in progress" on some boots.
  default[:sidekiq][application.intern][:restart_command] = "sleep 30 && sudo monit restart -g sidekiq_#{application}_group"
  default[:sidekiq][application.intern][:stop_command] = "sudo monit stop -g sidekiq_#{application}_group"
  default[:sidekiq][application.intern][:syslog] = false
end

