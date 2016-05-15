root = "#{Dir.getwd}"
threads 0,4
activate_control_app "tcp://127.0.0.1:3000"
bind "unix://#{root}/tmp/mappinglearning.sock"
pidfile "#{root}/tmp/puma.pid"
rackup "#{root}/config.ru"
state_path "#{root}/tmp/puma.state"