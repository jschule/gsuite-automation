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
test "$DATA_TRANSFER_RECIPIENT"

source _functions.sh

type="$1" ;  shift
case "$type" in
    (employee)
        info Moving employee accounts for deletion into $DELETE_OU OU
        $gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Löschen" matchfield Email "@" matchfield Type "$type" \
	        gam update user "~Email" \
            ou "$DELETE_OU"

# TODO: Reassign Courses, too !!!

        info Transferring all Drive data to $DATA_TRANSFER_RECIPIENT
        $gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Löschen" matchfield Email "@" matchfield Type "$type" \
	        gam create transfer "~Email" \
            drive "$DATA_TRANSFER_RECIPIENT" all wait 10 60

        info Deleting employee accounts after data transfer
        $gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Löschen" matchfield Email "@" matchfield Type "$type" \
	        gam delete user "~Email"
        ;;
    (student)
        info Deleting students accounts
        $gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Löschen" matchfield Email "@" matchfield Type "$type" \
	        gam delete user "~Email"
        ;;
    (*)
        echo '$type must be student or employee'
        exit 98
        ;;
esac

info Remove users from spreadsheet and run ./maintenance.sh