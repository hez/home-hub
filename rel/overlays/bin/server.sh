#!/bin/sh

. bin/config.sh
# export MIX_ENV=prod
PHX_SERVER=true bin/home_hub start >> logs/stdout.log 2>&1
