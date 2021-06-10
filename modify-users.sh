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

info Modify user accounts
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Konten Ändern" matchfield OldEmail "@" \
	gam update user "~OldEmail" \
    firstname "~First" \
    lastname "~Last" \
    username "~Username" \
    email "~Email" \
    ou "~OU"
    

exec ./maintenance.sh