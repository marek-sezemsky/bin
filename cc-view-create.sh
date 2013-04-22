#!/bin/env bash
#
# Create view with custom suffix for current user. Uses midgard as a view-server.
#
# If suffix is a number, consider it as a bugzilla bug and setup coresponding config-spec.
#

set -u
set -e
# set -x

# configuration
cleartool="/opt/rational/clearcase/bin/cleartool"
user="$(whoami)"
stgloc="/net/asgard/local/views"

# used to set config-spec
temp_file="/tmp/mkview.config_spec.$$"
trap "/bin/rm -f '$temp_file' " EXIT

setup_config_spec()
{
	tag=$1
	suffix=$2

	if [[ $suffix =~ '^[0-9]+$' ]]; then
		branch="devl_cfm_$suffix"
		echo "Config-spec for bug/branch: $branch"
		cat > $temp_file <<EOF
element * CHECKEDOUT
element * .../$branch/LATEST
mkbranch $branch
element * PROD
element * /main/LATEST
end mkbranch
EOF
	else
		echo "Config-spec for PROD."
		cat > $temp_file <<EOF
element * CHECKEDOUT
element * PROD
element * /main/LATEST
EOF
	fi

	cleartool setcs -tag $tag $temp_file
}

if [[ "$#" -ne 1 ]]; then
	echo "Usage: $0 <suffix> - will create create ${user}_<suffix> view" >&2
	exit 1
fi

suffix="$1"
tag="${user}_$suffix"
viewstore="${stgloc}/${user}/${tag}.vws"

# create an view
$cleartool mkview -tag $tag $viewstore

# setup cs
setup_config_spec $tag $suffix

# vim:fdm=indent
