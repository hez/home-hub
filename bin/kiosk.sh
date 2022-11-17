#!/bin/bash
while ! curl http://homehub.local
  do sleep 1
done
/usr/bin/chromium-browser --kiosk http://homehub.local/
