#!/bin/sh
#
# KVM CPU monitoring script for Nagios
# Origninal from https://github.com/rakesh-patnaik/nagios-openstack-monitoring
# Modified by Akshay Bhandari
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
    echo " -h                        Print help(this message) and exit"
    echo " -c <critical threshold>   Threshold for the critical CPU usage. Default 95 percent" 
    echo " -w <warning threshold>    Threshold for the warning CPU usage. Default 90 percent"
}

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

CRIT_THLD=95
WARN_THLD=90

while getopts 'h:c:w:' OPTION
do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        c)
            export CRIT_THLD=$OPTARG
            ;;
        w)
            export WARN_THLD=$OPTARG
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if ! which virsh >/dev/null 2>&1
then
    echo "UNKNOWN: virsh command not found"
    exit $STATE_UNKNOWN
fi

CPUUSAGE=$(virsh nodecpustats --percent | grep usage | awk '{print $2}' | cut -f1 -d'%')

if [ ! "$CPUUSAGE" ]; then
  echo "Unable to retrieve cpu usage"
  exit $STATE_UNKNOWN
fi

MSG="CPU usage at $CPUUSAGE%"

if [ $(awk -vx=$CPUUSAGE -vy=$CRIT_THLD 'BEGIN{ print x>=y?1:0}') -eq 1 ]; then
  echo "CRITICAL: $MSG"
  exit $STATE_CRITICAL
fi

if [ $(awk -vx=$CPUUSAGE -vy=$WARN_THLD 'BEGIN{ print x>=y?1:0}') -eq 1 ]; then
  echo "WARNING: $MSG"
  exit $STATE_WARNING
fi

echo "OK: $MSG"
exit $STATE_OK

