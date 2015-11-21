#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

. $(dirname $0)/include.sh;

CONF=$CONFIG_ROOT/nginx/conf.d/upstream.conf;
CONF_TPL=$CONFIG_ROOT/nginx/conf.d/upstream.conf.tpl;
VERSION=$1;
SOCKET=/run/zestedesavoir/$VERSION-socket;
SOCKETS="";

if [ -f $CONF ]; then
	# 1. Extract upstreams block
	# 2. Extract versions
	SOCKETS="$(\
		sed -n '/BEGIN DYNAMIC UPSTREAMS/,/END DYNAMIC UPSTREAMS/p' $CONF | \
		perl -n -e'/server unix:([[:alnum:]\/\.-]+)( down)?\;/ && print "$1\\n"' \
	)";
	COUNT=$(echo $SOCKETS | sed '/^\s*$/d' | wc -l);
	echo "\033[32m → $COUNT old upstreams found\033[0m";
else
	echo "\033[33m → No old upstream conf file found\033[0m";
fi;

SOCKETS="$SOCKETS$SOCKET";

SOCKETS=$(echo $SOCKETS | sort -u | perl -pe "s/\\n/ /g");

echo $SOCKETS;

UPSTREAMS="";
for S in $SOCKETS;
do
	if [ $S = $SOCKET ]; then
		UPSTREAMS="$UPSTREAMS  server unix:$S;\\n"
	else
		UPSTREAMS="$UPSTREAMS  server unix:$S down;\\n"
	fi;
done;

BLOCK="# BEGIN DYNAMIC UPSTREAMS\n\
$UPSTREAMS  # END DYNAMIC UPSTREAMS";

cat $CONF_TPL | perl -pe "s/  # DYNAMIC UPSTREAM/$(echo "$BLOCK" | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g')/" > $CONF;

echo "\033[32m → \033[4m$CONF\033[24m updated\033[0m";
