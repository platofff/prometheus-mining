#!/bin/bash
: '
prometheus-mining - Prometheus exporter for some mining software
Copyright (C) 2020 platofff

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
'

declare -A MINER_PORTS
MINER_PORTS['trm']='4028'
MINER_PORTS['t-rex']='4067'

check_command() {
	if ! command -v $1 &> /dev/null
	then
		echo "$1 not found, exiting."
		exit -1
	fi
}

check_command sed
check_command grep
check_command egrep
check_command nc
check_command curl
check_command jq
check_command awk
check_command lsof

if [ ! -f config ]
then
	echo '"config" file does not exists, trying to find rigs in your subnets...'
        subnets=( `ip -o -f inet addr show | awk '/scope global/ {print $4}'` )
	for miner in "${!MINER_PORTS[@]}"
	do
        	for s in "${subnets[@]}"
        	do
                	hosts+=' '`nmap --host-timeout 1s -oG - --open $s -p ${MINER_PORTS[$miner]} | grep ${MINER_PORTS[$miner]}/open | egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}"`
        	done
        	[ -z "$i" ] && i=1
        	for host in $hosts
        	do
                	echo "rig$i=( $miner $host ${MINER_PORTS[$miner]} )" >> config
                	i=$(( $i + 1 ))
        	done
		hosts=''
	done
	echo 'Found rigs:'
	cat config
fi

PORT=$1
[ -z "$PORT" ] && PORT=8080
if [ ! -z "$(lsof -i:$PORT)" ]
then
	echo "Port $PORT is already in use, please specify an another port."
	exit -2
fi
set -m

# Based on https://gist.github.com/alexey-sveshnikov/69d502aefd05a539c165
:;while [ $? -eq 0 ]
do
	nc -nvlp $PORT -c'(
		read a b c
		z=read
		while [ ${#z} -gt 2 ]
		do
			read z
		done
		f=`echo $b|sed 's/[^a-z0-9_.-]//gi'`
		H='HTTP/1.1'
		if [ "$f" = "metrics" ]
		then
			echo -n "$H 200 OK\r\n"
			./metrics
		else
			echo -e "$H 404 Not Found\n\n404\n"
		fi)'
done
