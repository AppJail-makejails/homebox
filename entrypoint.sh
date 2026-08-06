#!/bin/sh

. /lib.subr

set -e

create_user

change_owner /data

su-exec noroot homebox "$@"
