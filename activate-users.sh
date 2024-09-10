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
    (student)
        echo Activating students is not yet implemented because we would also have to temoporarily remove the parents from the parents mailing list
        exit 97
        ;;
    (employee)
        info Activating employee accounts
        ;;
    (*)
        echo '$type must be student or employee'
        exit 98
        ;;
esac

$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Aktivieren" matchfield Email "@" matchfield Type "$type" \
	gam unsuspend user "~Email"
    