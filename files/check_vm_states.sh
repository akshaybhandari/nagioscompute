#!/bin/sh
#
# KVM instance state monitoring script for Nagios
#
# Originally from: https://github.com/rakesh-patnaik/nagios-openstack-monitoring
# 
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

set -e

usage ()
{
    echo "Usage: $0 [OPTIONS]"
    echo " -h               Print help(this message) and exit"
    echo " -s <statename>   Name of the instance state to check. Defaults: crashed" 
}

MON_STATE=crashed

while getopts 'hH:s:' OPTION
do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        s)
            export MON_STATE=$OPTARG
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if ! which virsh >/dev/null 2>&1
then
    echo "virsh command not found"
    exit $STATE_UNKNOWN
fi

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

LIST=$(virsh list --all | sed '1,2d' | sed '/^$/d'| awk '{print $2":"$3}')

NUM=0
MON_STATE_CNT=0
MON_STATE_INST_NAMES="";

for host in $(echo $LIST)
do
  name=$(echo $host | awk -F: '{print $1}')
  state=$(echo $host | awk -F: '{print $2}')
  NUM=$(expr $NUM + 1)
  if echo $state | grep -i "^$MON_STATE$" > /dev/null 
  then
     MON_STATE_CNT=$(expr $MON_STATE_CNT + 1)
     MON_STATE_INST_NAMES="$MON_STATE_INST_NAMES $name"
  fi
done

if [ "$MON_STATE_CNT" -gt 0 ]; then
  echo "CRITICAL: $MON_STATE_CNT hosts in $MON_STATE state. Host names: $MON_STATE_INST_NAMES" 
  exit $STATE_CRITICAL
fi

echo "OK: $NUM hosts checked for state. None in state $MON_STATE."  
exit $STATE_OK

