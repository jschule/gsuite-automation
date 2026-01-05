#!/bin/bash

source _functions.sh

source config.sh

test "$MASTERSHEET"
test "$MASTERUSER"
test "$KITA"


info Update Mitarbeiter and Schüler in Master Data
$gam user $MASTERUSER clear sheetranges "$MASTERSHEET" range Schüler range Mitarbeiter

userlist="$($gam print user fields ou)"
# output is list of
# user@domain,/OU/Sub-OU
# the old ou_and_children method was sometimes not showing recently created accounts, unclear why.
# this is a workaround and performance improvement
grep ,/Mitarbeiter <<<"$userlist" | cut -d , -f 1 | $gam user "$MASTERUSER" \
    update sheetrange "$MASTERSHEET" \
    json file <(make_gam_sheet_update_json Mitarbeiter)

grep ,/Schüler <<<"$userlist" | cut -d , -f 1 | $gam user "$MASTERUSER" \
    update sheetrange "$MASTERSHEET" \
    json file <(make_gam_sheet_update_json Schüler)

echo
info Accounts in other OUs
grep -E -v ',/(Schüler|Mitarbeiter)' <<<"$userlist"

echo
echo "Delaying for G Sheets to settle down"
for x in $(seq 1 10) ; do echo -n ". "; sleep 1 ; done; echo

info Sync Mitarbeiter / Lehrer group with OU
# https://github.com/taers232c/GAMADV-XTD3/wiki/Collections-of-Users#users-directly-in-the-organization-unit-orgunititem
# https://github.com/taers232c/GAMADV-XTD3/wiki/Groups-Membership#synchronize-members-in-a-group
$gam update group allelehrer sync usersonly notsuspended ou /Mitarbeiter/Lehrer
$gam update group mitarbeiter@$KITA sync usersonly notsuspended ou /Mitarbeiter/Kita
$gam update group mitarbeiter sync usersonly notsuspended ou /Mitarbeiter

info Sync all student groups from master sheet data
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schülerverteiler" \
	gam update group "~Gruppe" \
	sync member usersonly users "~Mitglieder"

info Sync all parent groups from master sheet data
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Elternverteiler" \
	gam update group "~Gruppe" \
	sync member usersonly users "~Mitglieder"
