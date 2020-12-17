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

info Update Mitarbeiter and Schüler in Master Data
$gam user $MASTERUSER clear sheetranges "$MASTERSHEET" range Schüler range Mitarbeiter

$gam ou_and_children Mitarbeiter print user | $gam user "$MASTERUSER" \
    update sheetrange "$MASTERSHEET" \
    json file <(make_gam_sheet_update_json Mitarbeiter)

$gam ou_and_children Schüler print user | $gam user "$MASTERUSER" \
    update sheetrange "$MASTERSHEET" \
    json file <(make_gam_sheet_update_json Schüler)

info Sync Mitarbeiter / Lehrer group with OU
# https://github.com/taers232c/GAMADV-XTD3/wiki/Collections-of-Users#users-directly-in-the-organization-unit-orgunititem
# https://github.com/taers232c/GAMADV-XTD3/wiki/Groups-Membership#synchronize-members-in-a-group
$gam update group allelehrer sync usersonly notsuspended ou /Mitarbeiter/Lehrer
$gam update group mitarbeiter sync usersonly notsuspended ou /Mitarbeiter

info Sync all student groups from master sheet data
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schülerverteiler" \
	gam update group "~Gruppe" \
	sync member usersonly users "~Mitglieder"

info Sync all parent groups from master sheet data
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Elternverteiler" \
	gam update group "~Gruppe" \
	sync member usersonly users "~Mitglieder"
