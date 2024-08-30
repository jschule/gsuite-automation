#!/bin/bash

if [ ! "$1" ] ; then
    echo "Usage: $0 <student|employee>"
    exit 99
fi

set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

source config.sh

test "$MASTERSHEET"
test "$MASTERUSER"
test "$DELETE_OU"

source _functions.sh

type="$1" ;  shift
case "$type" in
    (student|employee)
        info Moving user accounts for $type deletion into $DELETE_OU OU
        ;;
    (*)
        echo '$type must be student or employee'
        exit 98
        ;;
esac

$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Löschen" matchfield Email "@" matchfield Type "$type" \
	gam update user "~Email" \
    ou "$DELETE_OU"

# would be nice to remove the license here
# https://github.com/taers232c/GAMADV-XTD3/wiki/Licenses

info remember to manually delete the users from $DELETE_OU

info Remove users from spreadsheet and run ./maintenance.sh