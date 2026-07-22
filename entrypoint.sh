#!/bin/sh

. /lib.subr

set -e

create_user

chown -R noroot:noroot /data

su-exec noroot homebox "$@"
