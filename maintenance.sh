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

# Sync Mitarbeiter / Lehrer group with OU
# https://github.com/taers232c/GAMADV-XTD3/wiki/Collections-of-Users#users-directly-in-the-organization-unit-orgunititem
# https://github.com/taers232c/GAMADV-XTD3/wiki/Groups-Membership#synchronize-members-in-a-group
$gam update group allelehrer sync usersonly notsuspended ou /Mitarbeiter/Lehrer
$gam update group mitarbeiter sync usersonly notsuspended ou /Mitarbeiter

# Sync all student groups from master sheet data
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schülerverteiler" \
	gam update group "~Gruppe" \
	sync member usersonly users "~Mitglieder"

# Sync all parent groups from master sheet data
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Elternverteiler" \
	gam update group "~Gruppe" \
	sync member usersonly users "~Mitglieder"


