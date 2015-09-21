#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>";
	exit 1;
fi;

. $(dirname $0)/include.sh;

CONF=$CONFIG_ROOT/nginx/conf.d/upstream.conf;
CONF_TPL=$CONFIG_ROOT/nginx/conf.d/upstream.conf.tpl;

UPSTREAMS="";

if [ -f $CONF ]; then
    # 1. Extract old upstreams
    # 2. Remove 1st and last line + "down"
    # 3. sort + uniq
    # 4. Add all down
    UPSTREAMS=$(\
        sed -n '/BEGIN DYNAMIC UPSTREAMS/,/END DYNAMIC UPSTREAMS/p' $CONF | \
        sed -e '1d' -e '$d' -e '/^$/d' -e 's/ down//g' | \
        sort | \
        uniq | \
        sed 's/server \(.*\);/server \1 down;/' \
    );
fi

UPSTREAMS="  server /var/run/zds-$VERSION.socket;\n" + $UPSTREAMS;
BLOCK="# BEGIN DYNAMIC UPSTREAMS
$UPSTREAMS
  # END DYNAMIC UPSTREAMS";
cat $CONF_TPL | sed "s/# DYNAMIC UPSTREAMS/${BLOCK}/" > $CONF;
