#!/bin/bash

set -e

CONFIG=/opt/gh2gl.conf
if [ ! -f "$CONFIG" ]; then
    echo "$CONFIG not found"
    exit 1
fi

source $CONFIG

mkdir -p $DIR

help () {
	echo -e "./gh2gl.sh create <ORGANIZATION> - create local repos from GitHub Organization for further mirroring (ssh-keys, github-cli & gitsync required)"
	echo -e "./gh2gl.sh sync <ORGANIZATION> - sync repos from GitHub to GitLab for Organization (ssh-keys, github-cli & gitsync required)"
}

create () {
	for i in $(gh repo list $ORGANIZATION -L 500 | awk '{print $1}'); do
		echo -e "\n \033[32m CREATE LOCAL REPO: $i \033[0m" 
		gitsync create git@github.com:$i.git $DIR/$i git@$GITLAB:$i.git
	done
}

sync () {
	for i in $(gh repo list $ORGANIZATION -L 500 | awk '{print $1}'); do
		echo -e "\n \033[32m SYNC REPO FROM GITHUB TO GITLAB: $i \033[0m"
		gitsync sync $DIR/$i
	done
}

check () {
	for i in $(gh repo list $ORGANIZATION -L 500 | awk '{print $1}'); do
		if [ ! -d "$DIR/$i" ]; then
			gitsync create git@github.com:$i.git $DIR/$i git@$GITLAB:$i.git
		fi
	done
}

parse_opts () {
	if [[ "$#" == "0" ]]; then
		help
	else
	while [[ ! -z "$*" ]]; do
		case "$1" in

			"create")
				shift 
				ORGANIZATION="$1"
				create
				shift
				;;
		
			"sync")
				shift
				ORGANIZATION="$1"
				check
				sync
				shift
				;;

			"help")
				help
				shift
				;;

			*)
				echo "Unknown options. Show ./gh2gl.sh help:"
				help
				break
				;;

		esac
	done
	fi
}

parse_opts $*


