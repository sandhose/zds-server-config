#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

INSTALL_ROOT=/opt/zestedesavoir;
TAG=$1;
TAG_BUILD=$TAG-build;

if [ -d $INSTALL_ROOT/instances/$TAG ]; then
	echo "[33m → [4m$INSTALL_ROOT/instances/$TAG[24m exists and will be deleted.";
	read -p "[0m   Continue installation? (y/N) " a;
	if [ "$a" = "y" -o "$a" = "Y" ]; then
		rm -rf $INSTALL_ROOT/instances/$TAG;
	else
		echo "[31m → Exiting[0m";
		exit 1;
	fi;
fi;


echo "[33m → Fetching tarball for $TAG[0m";
STATUS_CODE=$(curl -L --write-out '%{http_code}' -o /tmp/zds-$TAG.tar.gz https://codeload.github.com/zestedesavoir/zds-site/tar.gz/$TAG_BUILD);

# Check HTTP status code
if [ $STATUS_CODE -ne 200 ]; then
	echo "[31m → Failed to fetch tag $TAG_BUILD (HTTP code $STATUS_CODE). Exiting";
	exit 1;
fi;

echo "[33m → Extracting files[0m";
rm -rf /tmp/zds-site-*
tar -xzf /tmp/zds-$TAG.tar.gz -C /tmp;
cp -r /tmp/zds-site-*/ $INSTALL_ROOT/instances/$TAG;

echo "[33m → Cleaning up…[0m";
rm /tmp/zds-$TAG.tar.gz;
rm -rf /tmp/zds-site-*;

if [ -d $INSTALL_ROOT/instances/$TAG ]; then
	echo "[32m → $TAG installed in [4m$INSTALL_ROOT/instances/$TAG[0m";
	exit 0;
else
	echo "[31m → Directory doesn't exists. Installation failed[0m";
	exit 1;
fi
