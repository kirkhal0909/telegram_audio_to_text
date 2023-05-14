#!/bin/sh
if [ "$(uname)" == "Darwin" ]; then
  brew update
  brew install redis
else
  sudo apt-get update
  sudo apt-get install redis
fi
