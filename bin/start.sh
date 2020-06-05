#!/bin/sh

cd /home/pi/home-hub
# export MIX_ENV=prod
_build/prod/rel/home_hub/bin/home_hub start >> logs/stdout.log 2>&1
