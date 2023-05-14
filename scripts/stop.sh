#!/bin/sh
ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9
ps -ef | grep "ruby main.rb" | grep -v grep | awk '{print $2}' | xargs kill -9

if [ "$(uname)" == "Darwin" ]; then
  brew services stop redis
else
  sudo systemctl stop redis.service
fi

