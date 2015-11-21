#!/bin/sh

if [ $# -lt 1 ]; then
	echo "Usage: $0 <version> [command...]"
	exit 1
fi

VERSION=$1
shift

. $(dirname $0)/include.sh

$VENVS_ROOT/$VERSION/bin/python $APPS_ROOT/$VERSION/manage.py $*
exit $?
