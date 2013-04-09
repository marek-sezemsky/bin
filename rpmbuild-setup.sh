#!/bin/bash
#
# Setup RPM build for current non-root user. Install dependencies when
# required.
#

set -e
set -u
set -x

rpms="rpm-build redhat-rpm-config fedora-packager rpmdevtools buildsys-macros"
rpm -q $rpms || yum install $rpms

if [ $EUID -eq 0 ]; then
    echo "Must not build RPMs as root!" >&2
    exit 255
fi

# rpmdev-setuptree
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

if [ ! -f ~/.rpmmacros ]; then
    echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
fi
