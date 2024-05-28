#!/bin/sh

cd /home/pi/home_hub
. bin/config.sh
# export MIX_ENV=prod
export PHX_SERVER=true
bin/home_hub start >> logs/stdout.log 2>&1
