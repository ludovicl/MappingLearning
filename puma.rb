directory Dir.pwd
rackup File.join(Dir.pwd, 'config.ru')
environment 'production'
daemonize
pidfile File.join(Dir.pwd, 'tmp', 'production.pid')
state_path File.join(Dir.pwd, 'tmp', 'production.state')
threads 0,4
bind "unix://#{Dir.pwd}/tmp/production.sock"
