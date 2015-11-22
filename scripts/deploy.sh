#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <version>" >&2
	exit 1
fi

. $(dirname $0)/include.sh
VERSION=$1
SERVICE="zestedesavoir@`systemd-escape $VERSION`.service"

ask_yes () {
	while true; do
		read -p "$* (Y/n) " answer
		case $answer in
			[Nn]* ) return 1;;
			* ) return 0;;
		esac
	done
}

echo "Checking update…"
git -C $INSTALL_ROOT fetch -a
if [ "`git rev-parse HEAD`" != "`git rev-parse origin/master`" ]; then
	cat <<EOL
This tool is not up to date.
I can update it for you, or keep this version.
^C and run \`cd $INSTALL_DIR && git pull && sh scripts/install.sh\` to update it manually
EOL

	if ask_yes "Update it?"; then
		git -C $INSTALL_ROOT pull origin master
		echo "Updating config… (running scripts/install.sh)"
		sh $SCRIPTS_ROOT/install.sh
		sh $0 $1
		exit $?
	fi
fi

# Check if this version is installed
if [ -d $APPS_ROOT/$VERSION ] && [ -d $VENVS_ROOT/$VERSION ]; then
	echo "\033[33m → \033[4m$VERSION\033[24m seems to be already installed.\033[0m"

	# Check if this version is running
	systemctl is-active $SERVICE >/dev/null 2>/dev/null && echo "   This version seems to be running. It will be stopped first."
	IS_ACTIVE=$?

	if ask_yes "   Reinstall?"; then
		[ $IS_ACTIVE -eq 0 ] && systemctl stop $SERVICE
		sh $SCRIPTS_ROOT/install-version.sh $VERSION
	fi
else
	sh $SCRIPTS_ROOT/install-version.sh $VERSION
fi

while true; do
	cat <<EOL
Does this version need migration?
	1) No (start new version, then stop old version)
	2) Yes, automatic database migration (stop old version, migrate, start new version)
	3) Yes, manual migration (stop old version, start a shell in virtualenv, start new version)
EOL
	read -p "Choice (1/2/3) " answer
	case $answer in
		1) exit 1;;
		2) exit 2;;
		3) exit 3;;
		*) echo "Invalid choice";;
	esac
done
