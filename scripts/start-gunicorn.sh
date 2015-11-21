#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>"
	exit 1
fi

. $(dirname $0)/include.sh

VERSION=$1

RUN=/run/zestedesavoir/$VERSION
VENV=$VENVS_ROOT/$VERSION
APP=$APPS_ROOT/$VERSION

cd $APP

$VENV/bin/gunicorn -b unix:$RUN-socket -w 7 --chdir $APP -p $RUN-pid --pythonpath $VENV zds.wsgi

exit $?
