#!/bin/bash
#
# $1 = Typ (parent or student)
# $2 = Klasse, e.g. 34 or 910a
# $3... = Schüler/Eltern/Lehrer emails


if [ ! "$3" ] ; then
    echo "Usage: $0 <student|parent> class email [email...]"
    echo "Example: $0 parent 910a user@domain user2@domain2"
    exit 99
fi

set -o pipefail -o errexit -o nounset

gam="$HOME/bin/gamadv-xtd3/gam"

if [ ! -x "$gam" ] ; then
    echo "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
    exit 98
fi

typ="$1"; shift
class="$1" ; shift
case "$typ" in
    (student)
        group="verteiler-$class"
        name="$class-Verteiler JTS"
        subjectprefix="[Verteiler $class]"
        managers=""
        groupsettings=(
            whocandiscovergroup all_in_domain_can_discover
            whocanpostmessage all_in_domain_can_post
            whocanmoderatemembers none
            whocanmoderatecontent none
            whocanjoin invited_can_join
            whocanleavegroup none_can_leave
            whocanviewgroup all_members_can_view
            whocanviewmembership all_in_domain_can_view
        )
        extrahint=""
        ;;
    (parent)
        group="eltern-$class"
        name="Eltern-Klasse-$class JTS"
        managers="bettina.wolf"
        subjectprefix="[Eltern $class]"
        groupsettings=(
            whocandiscovergroup all_in_domain_can_discover
            whocanpostmessage all_in_domain_can_post
            whocanmoderatemembers owners_and_managers
            whocanmoderatecontent none
            whocanjoin invited_can_join
            whocanleavegroup none_can_leave
            whocanviewgroup all_members_can_view
            whocanviewmembership all_managers_can_view
            allowexternalmembers true
        )
        extrahint="* Standardfooter aktivieren"
        ;;
    (*)
        echo "Typ must be student or parent"
        exit 98
        ;;
esac
members="$*"

csvfile=$(mktemp -t $(basename $0))
trap "rm -f $csvfile" 0
function showerrorsfromcsv {
    echo "ERRORS: Please check and fix manually"
    grep -iE "warn|err|fail" $csvfile || echo "No errors found: $(< $csvfile)"
}

need_manual_setup=""
if $gam create group  "$group" ; then
    need_manual_setup=yes
else
    echo "Gruppe existiert vermutlich schon, wir versuchen es weiter."
fi

for x in $(seq 1 5) ; do echo -n ". "; sleep 1 ; done; echo

# set name & description
$gam update group "$group" \
    name "$name" \
    description "$name"

# set group settings
# experiments showed that I need a separate GAM call for this to work
$gam update group "$group" \
    primarylanguage de \
    replyto reply_to_sender \
    "${groupsettings[@]}"

# clear members
$gam redirect csv $csvfile \
    update group "$group" \
    delete actioncsv \
    group "$group" || showerrorsfromcsv

# add managers
if test "$managers" ; then
    $gam redirect csv $csvfile \
        update group "$group" \
        add managers delivery nomail actioncsv \
        "$managers" || showerrorsfromcsv
fi

# add members
$gam redirect csv $csvfile \
    update group "$group" \
    add members actioncsv \
    "$members" || showerrorsfromcsv

$gam show group-members group "$group"
$gam info group "$group" | grep -iE 'verteiler|eltern|whocanjoin|whocanview|whocanmoderate|allowext|primaryl'

# set manual settings
if test "$need_manual_setup" ; then
    echo "Bitte in der Weboberfläche https://groups.google.com/a/jschule.de/g/$group/settings noch einstellen:"
    echo "* das Emailprefix auf '$subjectprefix' setzen"
    echo "* Conversation history einschalten"
    echo "$extrahint"
fi