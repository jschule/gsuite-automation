#!/bin/bash
#
# $1 = Klasse, e.g. 34 or 910a


if [ ! "$1" ] ; then
    echo "Usage: $0 class"
    echo "Example: $0 910a"
    exit 99
fi

set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

class="$1"
user="eltern-$class"
name="Eltern-Klasse-$class JTS"

$gam create group  "$user"
for x in $(seq 1 5) ; do echo -n ". "; sleep 1 ; done; echo
$gam update group "$user" \
    name "$name" \
    description "$name"
$gam update group "$user" \
    primarylanguage de \
    whocandiscovergroup all_members_can_discover \
    whocanjoin invited_can_join \
    whocanmoderatemembers owners_and_managers \
    whocanviewmembership all_managers_can_view \
    allowexternalmembers true
$gam info group "$user" | grep -iE 'eltern|whocanview|whocanmoderate|allowext|primaryl'
