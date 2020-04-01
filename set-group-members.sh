#!/bin/bash
#
# $1 = Klasse, e.g. 34 or 910a


if [ ! "$1" ] ; then
    echo "Usage: $0 Gruppe"
    echo "Example: $0 verteiler-99"
    exit 99
fi

set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

function readlist {
    data=()
    while read -e ; do
        [ -z "$REPLY" ] && break 
        data+=( $REPLY ) # use bash to separate words!
    done
    [ "${#data[*]}" -gt 0 ] && echo "${data[*]}" || echo
}


csvfile=$(mktemp -t $(basename $0))
trap "rm -f $csvfile" 0
function showerrorsfromcsv {
    echo "ERRORS: Please check and fix manually"
    grep -iE "warn|err|fail" $csvfile || echo "No errors found: $(< $csvfile)"
}

group="$1"

echo "Set Managers (nomail), end with empty line"
managers="$(readlist)"
echo "Set Members, end with empty line"
members="$(readlist)"
declare -p managers members

$gam redirect csv $csvfile update group "$group" delete actioncsv group "$group" || showerrorsfromcsv
$gam redirect csv $csvfile update group "$group" add managers delivery nomail actioncsv "$managers" || showerrorsfromcsv
$gam redirect csv $csvfile update group "$group" add members actioncsv "$members" || showerrorsfromcsv
$gam show group-members group "$group"