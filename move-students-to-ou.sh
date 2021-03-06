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

info Move all students to their OU
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schüler" \
	gam update user "~Email" \
	ou "~OU"
