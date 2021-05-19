#!/bin/bash
: '
prometheus-mining - Prometheus exporter for some mining software
Copyright (C) 2020-2021 platofff

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

if [ -z "$RIGS" ]
then
	echo 'RIGS environment variable is empty. Exiting.'
	exit -1
fi
echo $RIGS > config

exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
