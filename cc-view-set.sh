#!/bin/env bash
#
# $0 [<view>]
#
# Wrapper to start ClearCase view specified by view argument (defaults to
# `whoami` if none is given). Script starts first view that exists:
#
# ${USER}_${view}
# ${LOCAL_VIEW_PREFIX}_${view}
# ${view}
#
# Shows short config-spec of started view. View is started with
# $LOCAL_VIEW_SHELL, or default $SHELL.
#

set -u
set -e
# set -x

source $(dirname $0)/functions
source $(dirname $0)/functions-cc

exec_view_set() # {{{
{
    local view_tag=$1

    echo "===== $view_tag ====="
    $cleartool startview $view_tag

    # brief config-spec output, strip comments and empty lines
    $cleartool catcs -tag $view_tag | egrep -v '^\s*(#.*)?$'

    # exec my favourite bash in view, regardles of default shell
    exec $cleartool setview -exec "$shell" $view_tag
} # }}}

default_shell="${SHELL:-/bin/sh}"
shell="${LOCAL_VIEW_SHELL:-$default_shell}"

user="$(whoami)"
view=${1:-$user}

views="${view} ${user}_${view} ${LOCAL_VIEW_PREFIX}_${view}"
for tag in $views; do
    if view_present $tag; then
        exec_view_set $tag
    else
        msg_warning "View $tag not found."
    fi
done

exit_error "Failed to find view for '$view'."

# vim:foldmethod=marker:ts=4:sw=4:st=4:expandtab:tw=78
