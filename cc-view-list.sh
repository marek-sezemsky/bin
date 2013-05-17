#!/bin/env bash
#
# $0 [prefix]
#
# List view with ${prefix}*, ${user}* or ${LOCAL_VIEW_PREFIX}*
#

set -u
set -e
# set -x

cleartool=/opt/rational/clearcase/bin/cleartool

if [ -n "${1:-}" ]; then
    prefix="${1}"
elif [ -n "${LOCAL_VIEW_PREFIX:-}" ]; then
    prefix="${LOCAL_VIEW_PREFIX}"
else
    prefix="$(whoami)"
fi

set -f  # disable globbing for lsview cn880*

$cleartool lsview ${prefix}* | sort
