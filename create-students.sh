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

info Create student accounts
# https://github.com/taers232c/GAMADV-XTD3/wiki/Users#create-a-user
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schüler neu" \
    gam create user "~Email" \
        password "~Passwort" \
        ou "~OU" \
        firstname "~Vorname" \
        lastname "~Nachname"

info Waiting a bit for Google to settle down
for x in $(seq 1 10) ; do echo -n ". "; sleep 1 ; done; echo

exec ./maintenance.sh
