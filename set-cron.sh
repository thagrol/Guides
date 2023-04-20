#!/bin/bash

# configure interactive shell to simulate running under cron
# call from a shell running as the desired user
# or via sudo -u username
# or via sudo -u username

pushd $HOME

env -i PS1="$LOGNAME:cron test $ " HOME=$HOME LOGNAME=$LOGNAME LANG=$LANG SHELL=/bin/sh PATH=/usr/bin:/bin /bin/sh

popd
