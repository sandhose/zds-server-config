#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

. $(dirname $0)/include.sh;

VERSION=$1;

echo "\033[33m → Installing $VERSION\033[0m";

sh $SCRIPTS_ROOT/fetch-version.sh $VERSION;
if [ $? -ne 0 ]; then
	echo "\033[31m → Failed to install version $VERSION. Aborting\033[0m";
	exit 1;
fi;

sh $SCRIPTS_ROOT/mkvirtualenv.sh $VERSION;
if [ $? -ne 0 ]; then
	echo "\033[31m → Failed to create virtualenv. Aborting\033[0m";
	exit 1;
fi;

VENV=$VENVS_ROOT/$VERSION;
APP=$APPS_ROOT/$VERSION;

echo "\033[33m → Installing pip dependencies\033[0m";
$VENV/bin/pip install -r $APP/requirements.txt -r $CONFIG_ROOT/requirements-prod.txt;
if [ $? -ne 0 ]; then
	echo "\033[31m → Failed to install pip dependencies.\033[0m";
	exit 1;
fi;

echo "\033[33m → Processing \033[4msettings_prod.py\033[0m";
TEMPLATE=$(cat $CONFIG_ROOT/settings_prod.py)
eval "echo \"${TEMPLATE}\"" > $APP/zds/settings_prod.py;

echo "\033[32m → Version $VERSION installed\033[0m";
