#!/bin/env bash
#
# $0
#
# List view with prefix ${user} or ${LOCAL_VIEW_PREFIX}
#

set -u
set -e
# set -x

set -f  # disable globbing for lsview cn880*

cleartool=/opt/rational/clearcase/bin/cleartool

user="$(whoami)"
prefixes="${1:-$user}*"
if [ -n "${LOCAL_VIEW_PREFIX:-}" ]; then
    prefixes="$prefixes ${LOCAL_VIEW_PREFIX}*"
fi

exec $cleartool lsview $prefixes | sort
