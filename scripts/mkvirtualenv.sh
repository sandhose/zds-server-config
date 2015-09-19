#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

INSTALL_ROOT=/opt/zestedesavoir;
VERSION=$1;

if [ -d $INSTALL_ROOT/virtualenvs/$VERSION ]; then
	echo "[33m → [4m$INSTALL_ROOT/virtualenvs/$VERSION[24m exists.[0m";
	read -p "   Delete before installing ? (y)es/(n)o/(Q)uit " a;
	case $a in
		[yY]*) rm -rf $INSTALL_ROOT/virtualenvs/$VERSION;;
		[nN]*) exit 0;;
		*) exit 1;;
	esac;
fi;

echo "[33m → Creating virtualenv…[0m";
virtualenv -p python2 $INSTALL_ROOT/virtualenvs/$VERSION;

if [ -d $INSTALL_ROOT/virtualenvs/$VERSION ]; then
	echo "[32m → Done ![0m";
        echo "   Activate virtualenv using [4msource $INSTALL_ROOT/virtualenvs/$VERSION/bin/activate[0m";
else
	echo "[31m → virtualenv creation failed :([0m";
	exit 1;
fi;

