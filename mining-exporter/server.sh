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
MINER_PORTS['lolminer']='4069'
SUBNETS=( '192.168.1.1/24' )

if [ ! -f config ]
then
        rm rigsoffline 2> /dev/null
	echo '"config" file does not exists, trying to find rigs in configured subnets...'
	for miner in "${!MINER_PORTS[@]}"
	do
        	for s in "${SUBNETS[@]}"
        	do
			echo "Trying to find $miner miners in $s subnet..."
                	hosts+=' '`nmap -oG - --open $s -p "${MINER_PORTS[$miner]}" | grep "${MINER_PORTS[$miner]}"/open | egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}"`
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
	cat config || (echo 'No rigs found. Fill "config" file by yourself and try again.' && exit -1)
fi

if [ ! -f rigsoffline ]
then
	echo '"rigsoffline" file not found. Fetching stats from all miners.'
	cd cgi-bin
	resp=`./metrics | sed -r 's/( *[0-9])+$//; s/([0-9][0-9]\.)+$//; s/ $|$/ 0/; /^#.*.|Content|^ 0/d'`
	cd ..
	source config
	RIGS=( `sed 's/=.*//g' config` )

	for r in "${RIGS[@]}"
	do
        	rig=$r[@]
        	rig=( ${!rig} )
        	echo "${r}offline='`grep ${rig[1]} <<< $resp`'" >> rigsoffline
	done
fi

PORT=$1
[ -z "$PORT" ] && PORT=8080
if [ ! -z "$(lsof -i:$PORT)" ]
then
	echo "Port $PORT is already in use, please specify an another port."
	exit -2
fi

exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
