#!/bin/sh

cd /home/pi/home-hub
. bin/config.sh
# export MIX_ENV=prod
export PHX_SERVER=true
_build/prod/rel/home_hub/bin/home_hub start >> logs/stdout.log 2>&1
