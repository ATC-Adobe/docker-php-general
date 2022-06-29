#!/usr/bin/env bash

trap "{ echo Stopping postfix; /usr/sbin/postmulti -i - -p stop; exit 0; }" EXIT
/usr/lib/postfix/configure-instance.sh -
/usr/sbin/postmulti -i - -p start
sleep infinity