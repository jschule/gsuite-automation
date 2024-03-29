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
test "$NOTIFICATIONUSERS"

source _functions.sh

info Create employee accounts
# https://github.com/taers232c/GAMADV-XTD3/wiki/Users#create-a-user
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Mitarbeiter neu" \
    gam create user "~Email" \
        password "$STARTPASSWORD" \
        ou "~OU" \
        firstname "~Vorname" \
        lastname "~Nachname" \
        changepasswordatnextlogin true \
        notify "$NOTIFICATIONUSERS" \
        subject "Neues JTS Konto #givenname# #familyname#" \
        file new-employee-notification.txt

info Waiting a bit for Google to settle down
for x in $(seq 1 10) ; do echo -n ". "; sleep 1 ; done; echo

./maintenance.sh

cat <<EOF
*** Done

Please update groups and make sure to run ./maintenance.sh at the end

You can now remove the "Neu" tag from these new users.
EOF
