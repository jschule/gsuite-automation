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
test "$STARTPASSWORD"

function info {
    # print info headergit 
    echo -e "*\n*\n*\n***  $*  ***\n*"
}

info Create employee accounts
# https://github.com/taers232c/GAMADV-XTD3/wiki/Users#create-a-user
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Mitarbeiter neu" \
    gam create user "~Email" \
        password "$STARTPASSWORD" \
        ou "~OU" \
        firstname "~Vorname" \
        lastname "~Nachname" \
        changepasswordatnextlogin true

exec ./maintenance.sh
