#!/bin/bash
set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

# Sync teachers group with OU
# https://github.com/taers232c/GAMADV-XTD3/wiki/Collections-of-Users#users-directly-in-the-organization-unit-orgunititem
# https://github.com/taers232c/GAMADV-XTD3/wiki/Groups-Membership#synchronize-members-in-a-group
$gam update group allelehrer sync ou /Mitarbeiter/Lehrer