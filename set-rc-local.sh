#!/bin/bash

# configure interactive shell to simulate running under rc.local
#   does not set JOURNAL_STREAM and INVOCATION_ID
# must be run as root or with sudo

if [ $# != 0 ]; then
	echo "must be root" > /dev/stderr
	exit 1
fi

pushd /

env -i PS1="rc.local test $ " TERM=linux LANG=$LANG PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin sh

popd
