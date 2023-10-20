#!/bin/bash
while ! curl http://homehub.local
  do sleep 1
done
/usr/bin/firefox --kiosk http://homehub.local/
