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

function make_gam_sheet_update_json {
    # read list from stdin and generate GAM Sheet update json for named range
    range="$1"; shift
    jq -n --slurpfile data <(jq -R '[.]') '[{"range":"'"$range"'","majorDimension":"ROWS"}] | .[0].values=$data'

}

function info {
    # print info headergit 
    echo -e "*\n*\n*\n***  $*  ***\n*"
}

info Move all students to their OU
$gam loop gsheet "$MASTERUSER" "$MASTERSHEET" "gam Schüler" \
	gam update user "~Email" \
	ou "~OU"
