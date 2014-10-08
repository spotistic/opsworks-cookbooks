include_attribute 'deploy'

default[:rubber] = {}
default[:rubber][:commands] = {
  :start => 'sudo start rubber',
  :stop => 'sudo stop rubber',
  :restart => 'sudo start rubber || sudo restart rubber'
}
default[:rubber][:config] = {}
default[:rubber][:config][:concurrency] = 20
default[:rubber][:config][:queues] = []
