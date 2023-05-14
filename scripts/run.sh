#!/bin/sh
if [ "$(uname)" == "Darwin" ]; then
  brew services start redis
else
  sudo systemctl start redis.service
fi

mkdir -p tmp

bundle exec sidekiq -C configs/sidekiq.yml -r ./lib/boot.rb > tmp/sidekiq.logs &

ruby main.rb
