#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

INSTALL_ROOT=/opt/zestedesavoir;
SCRIPTS_ROOT=$INSTALL_ROOT/scripts;
VERSION=$1;

echo "[33m → Installing $VERSION[0m";

sh $SCRIPTS_ROOT/mkvirtualenv.sh $VERSION;
if [ $? -ne 0 ]; then
	echo "[31m → Failed to create virtualenv. Aborting[0m";
	exit 1;
fi;

sh $SCRIPTS_ROOT/fetch-version.sh $VERSION;
if [ $? -ne 0 ]; then
	echo "[31m → Failed to install version $VERSION. Aborting[0m";
	exit 1;
fi;

VENV=$INSTALL_ROOT/virtualenvs/$VERSION;
APP=$INSTALL_ROOT/instances/$VERSION;

echo "[33m → Installing pip dependencies[0m";
$VENV/bin/pip install -r $APP/requirements.txt -r $INSTALL_ROOT/config/requirements-prod.txt;
if [ $? -ne 0 ]; then
	echo "[31m → Failed to install pip dependencies.[0m";
	exit 1;
fi;

echo "[32m → Version $VERSION installed[0m";
