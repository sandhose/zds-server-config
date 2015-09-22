#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

. $(dirname $0)/include.sh;

###
# TODO: Clean up + doc
###

CONF=$CONFIG_ROOT/nginx/conf.d/upstream.conf;
CONF_TPL=$CONFIG_ROOT/nginx/conf.d/upstream.conf.tpl;
VERSION=$1;
SOCKET=/var/run/zds-$VERSION.socket;
SOCKETS="";

if [ -f $CONF ]; then
    # 1. Extract upstreams block
    # 2. Extract versions
    SOCKETS="$(\
        sed -n '/BEGIN DYNAMIC UPSTREAMS/,/END DYNAMIC UPSTREAMS/p' $CONF | \
        perl -n -e'/server ([[:alnum:]\/\.-]+)( down)?\;/ && print "$1\\n"' \
    )";
fi

SOCKETS="$SOCKETS$SOCKET";

SOCKETS=$(echo $SOCKETS | sort -u);

UPSTREAMS="";
for S in $SOCKETS;
do
	if [ $S = $SOCKET ]; then
		UPSTREAMS="$UPSTREAMS  server $S;\\n"
	else
		UPSTREAMS="$UPSTREAMS  server $S down;\\n"
	fi;
done;

BLOCK="# BEGIN DYNAMIC UPSTREAMS\n\
$UPSTREAMS  # END DYNAMIC UPSTREAMS";
cat $CONF_TPL | perl -pe "s/  # DYNAMIC UPSTREAM/$(echo "$BLOCK" | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')/";
