#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

. $(dirname $0)/include.sh

VERSION=$1;

if [ -d $VENVS_ROOT/$VERSION ]; then
	echo "\033[33m → \033[4m$VENVS_ROOT/$VERSION\033[24m exists.\033[0m";
	read -p "   Delete before installing ? (y)es/(n)o/(Q)uit " a;
	case $a in
		[yY]*) rm -rf $VENVS_ROOT/$VERSION;;
		[nN]*) exit 0;;
		*) exit 1;;
	esac;
fi;

echo "\033[33m → Creating virtualenv…\033[0m";
virtualenv -p python2 $VENVS_ROOT/$VERSION;

if [ -d $VENVS_ROOT/$VERSION ]; then
	echo "\033[32m → Done !\033[0m";
	echo "   Activate virtualenv using \033[4msource $VENVS_ROOT/$VERSION/bin/activate\033[0m";
else
	echo "\033[31m → virtualenv creation failed :(\033[0m";
	exit 1;
fi;

