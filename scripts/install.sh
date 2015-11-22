#!/bin/sh

if [ $# -ne 0 ]; then
	echo "Usage: $0" 1>&2
	exit 1
fi

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

. $(dirname $0)/include.sh

cat <<EOL
This script will
 - symlink $CONFIG_ROOT/systemd/* to /etc/systemd/system/
 - reload systemd deamon (systemctl daemon-reload)
 - stop and disable system nginx service if started (systemctl stop nginx.service && systemctl disable nginx.service)
 - start (or reload) and enable custom nginx (systemctl start/reload nginx-zds.service && systemctl enable nginx-zds.service)
 - enable systemd timers (systemctl enable zds-solr-index.timer && systemctl enable zds-clear-sessions.timer)

EOL

while true; do
	read -p "Proceed? (y/N) " answer
	case $answer in
		[YyOo]* ) break;;
		* ) exit;;
	esac
done

echo "Symlinking systemd services"
for F in `ls $CONFIG_ROOT/systemd/`; do
	if [ -L /etc/systemd/system/$F ]; then
		rm /etc/systemd/system/$F
	elif [ -e /etc/systemd/system/$F ]; then
		echo "/etc/systemd/system/$F already exists, and is not a symbolic link. Exiting" >&2
		exit 2
	fi

	ln -s $CONFIG_ROOT/systemd/$F /etc/systemd/system/
done

if ! [ -f $CONFIG_ROOT/nginx/conf.d/upstream.conf ]; then
	sh $SCRIPTS_ROOT/select-nginx-version.sh clear
fi

if ! [ -d /var/log/zestedesavoir/ ]; then
	mkdir -p /var/log/zestedesavoir/
	chown zds:zds /var/log/zestedesavoir/
fi

systemctl daemon-reload

systemctl is-active nginx.service >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	echo "Stopping nginx.service"
fi

systemctl is-enabled nginx.service >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	echo "Disabling nginx.service"
fi

systemctl is-active nginx-zds.service >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	echo "Reloading nginx-zds.service"
	systemctl reload nginx-zds.service
else
	echo "Starting nginx-zds.service"
	systemctl start nginx-zds.service
fi

systemctl is-enabled nginx-zds.service >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	echo "Enabling nginx-zds.service"
	systemctl enable nginx-zds.service
fi

# Timers are not ready yet
#echo "Enabling timers"
#systemctl enable zds-solr-index.timer
#systemctl start zds-solr-index.timer
#systemctl enable zds-clear-sessions.timer
#systemctl start zds-clear-sessions.timer

echo "Done!"
