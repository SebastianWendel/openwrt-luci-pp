#!/bin/sh
# /usr/lib/perfectprivacy/pp_control.sh
#
# Written by Frank Schiebel, August 2012
# Distributed under the terms of the GNU General Public License (GPL) version 2.0

# source funtions
. /usr/lib/perfectprivacy/pp_functions.sh

# load_all_config_options to load config
load_all_config_options "perfectprivacy" "PerfectPrivacy"

# This gets the following variables
# echo $username
# echo $server_name
# echo $password
# echo $enabled
# echo $persistent
# echo $check_interval

# (re)write the list of available servers
write_server_list
# write auth file to use as cmd-line argument for openvpn command
write_auth_file "$username" "$password"

while true; do 

get_openvpn_pid
if [ "x${pid}" != "x" ]; then 
	kill -15 $pid
	rm -f /usr/lib/perfectprivacy/status/openvpn.pid
	rm -f /usr/lib/perfectprivacy/status/openvpn.server
fi

if [ $enabled ]; then
    if [ "x${pid}" == "x" ]; then
	openvpn --cd /usr/lib/perfectprivacy/openvpn \
		--config "${server_name}.ovpn" \
		--auth-nocache \
		--auth-user-pass /usr/lib/perfectprivacy/auth.conf > /dev/null 2>&1 &
	sleep 2
	get_openvpn_pid
	echo $pid > /usr/lib/perfectprivacy/status/openvpn.pid
	echo $server_name >/usr/lib/perfectprivacy/status/openvpn.server
    fi
fi

get_openvpn_pid
get_active_server

while [ "x${pid}" != "x" -a "$active_server" == "$server_name" ]; do
	sleep $check_interval
	load_all_config_options "perfectprivacy" "PerfectPrivacy"
	get_openvpn_pid
	get_active_server
done

#while 1
done 

return 0
