#!/bin/bash
set -e -x
echo "starting supervisor in foreground"
supervisord -c /etc/supervisor/supervisord.conf -n
