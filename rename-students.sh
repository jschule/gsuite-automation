#!/bin/bash
set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

source config.sh

test "$MASTERSHEET"
test "$MASTERUSER"

source _functions.sh

info Rename students
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schüler Umbenennen" matchfield Alt "@" \
	gam update user "~Alt" \
    firstname "~First" \
    lastname "~Last" \
    username "~Username" \
    email "~Email"

exec ./maintenance.sh