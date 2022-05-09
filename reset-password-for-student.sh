#!/bin/bash
set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

if [ ! "$1" ] ; then
    echo "Usage: $0 <student>"
    echo "Example: $0 test.schuelerin"
    exit 99
fi

source config.sh

test "$MASTERSHEET"
test "$MASTERUSER"

source _functions.sh

student="$1" ; shift

if [[ "$student" != *@* ]] ; then
    # student either has @ in it or we append it to make sure that we only match full emails or full username
    student="$student@"
fi
info Reset password for single student "$student"

$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schüler" matchfield Email "^$student" \
	gam update user "~Email" \
	password "~Passwort"
