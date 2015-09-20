#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

INSTALL_ROOT=/opt/zestedesavoir;
TAG=$1;
TAG_BUILD=$TAG-build;

if [ -d $INSTALL_ROOT/instances/$TAG ]; then
	echo "\033[33m → \033[4m$INSTALL_ROOT/instances/$TAG\033[24m exists and will be deleted.\033[0m";
	read -p "   Continue installation? (y/N) " a;
	if [ "$a" = "y" -o "$a" = "Y" ]; then
		rm -rf $INSTALL_ROOT/instances/$TAG;
	else
		exit 1;
	fi;
fi;


echo "\033[33m → Fetching tarball for $TAG\033[0m";
STATUS_CODE=$(curl -L --write-out '%{http_code}' -o /tmp/zds-$TAG.tar.gz https://codeload.github.com/zestedesavoir/zds-site/tar.gz/$TAG_BUILD);

# Check HTTP status code
if [ $STATUS_CODE -ne 200 ]; then
	echo "\033[31m → Failed to fetch tag $TAG_BUILD (HTTP code $STATUS_CODE). Exiting";
	exit 1;
fi;

echo "\033[33m → Extracting files\033[0m";
rm -rf /tmp/zds-site-*
tar -xzf /tmp/zds-$TAG.tar.gz -C /tmp;
cp -r /tmp/zds-site-*/ $INSTALL_ROOT/instances/$TAG;

echo "\033[33m → Cleaning up…\033[0m";
rm /tmp/zds-$TAG.tar.gz;
rm -rf /tmp/zds-site-*;

if [ -d $INSTALL_ROOT/instances/$TAG ]; then
	echo "\033[32m → $TAG installed in \033[4m$INSTALL_ROOT/instances/$TAG\033[0m";
	exit 0;
else
	echo "\033[31m → Directory doesn't exists. Installation failed\033[0m";
	exit 1;
fi
