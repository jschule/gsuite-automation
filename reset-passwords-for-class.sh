#!/bin/bash
set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

if [ ! "$1" ] ; then
    echo "Usage: $0 <class>"
    echo "Example: $0 3"
    exit 99
fi

source config.sh

test "$MASTERSHEET"
test "$MASTERUSER"

source _functions.sh

student="$1" ; shift

info Reset password for all students in class "$class"
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schüler" matchfield Klasse "^$class$" \
	gam update user "~Email" \
	password "~Passwort"
