#!/bin/sh

if [ ! $_ZDS_CONF_LOADED ]; then
	export INSTALL_ROOT=/opt/zestedesavoir;
	export SCRIPTS_ROOT=$INSTALL_ROOT/scripts;
	export CONFIG_ROOT=$INSTALL_ROOT/config;
	export VENVS_ROOT=$INSTALL_ROOT/virtualenvs;
	export APPS_ROOT=$INSTALL_ROOT/instances;
	export DATA_ROOT=$INSTALL_ROOT/data;
	export _ZDS_CONF_LOADED=1;

	if [ -f $CONFIG_ROOT/config_secret.sh ]; then
		. $CONFIG_ROOT/config_secret.sh;
	else
		echo "\033[33m → Warning: \033[4m$CONFIG_ROOT/config_secret.sh\033[24m not found\033[0m";
	fi;
fi;
