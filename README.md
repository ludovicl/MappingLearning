#Deploy

## With puma

    cat tmp/pids/puma.pid | xargs kill
    bundle exec puma -C puma.rb -e production

## With config.ru file

    rackup -o 0.0.0.0 -p 3000 config.ru
