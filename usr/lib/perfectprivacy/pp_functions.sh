# /usr/lib/perfectprivacy/pp_functions.sh
#
# Written by FRank Schiebel, August 2012
# Distributed under the terms of the GNU General Public License (GPL) version 2.0

. /etc/functions.sh


#loads all options for a given package and section
#also, sets all_option_variables to a list of the variable names
load_all_config_options()
{
	pkg_name="$1"
	section_id="$2"

	ALL_OPTION_VARIABLES=""
	config_cb()
	{
		if [ ."$2" = ."$section_id" ]; then
			option_cb()
			{
				ALL_OPTION_VARIABLES="$ALL_OPTION_VARIABLES $1"
			}
		else
			option_cb() { return 0; }
		fi
	}


	config_load "$pkg_name"
	for var in $ALL_OPTION_VARIABLES
	do
		config_get "$var" "$section_id" "$var"
	done
}

write_server_list() 
{
	rm -f /usr/lib/perfectprivacy/servers
	cd /usr/lib/perfectprivacy/openvpn
	IFS=$'\n'
	for cfile in `ls *.ovpn`; do
		basename $cfile .ovpn >> /usr/lib/perfectprivacy/servers
	done
	unset IFS
}

write_auth_file()
{
	echo $1 >  /usr/lib/perfectprivacy/auth.conf
	echo $2 >> /usr/lib/perfectprivacy/auth.conf
	chmod 600 /usr/lib/perfectprivacy/auth.conf
}

get_openvpn_pid()
{
	pid=`ps ax | grep perfectprivacy | grep -v grep | awk '{print $1}'`
}

get_active_server()
{
	active_server=`cat /usr/lib/perfectprivacy/status/openvpn.server`
}

