#!/bin/bash

source _functions.sh

source config.sh

test "$MASTERSHEET"
test "$MASTERUSER"
test "$STUDENT_PARENTS_GROUP_MANAGERS"


info Update all parents groups configuration and managers
# For some strange reason the query also returns the elternvertreter group, filtering that out in GAM
parentsgroups=$($gam print groups query "email:eltern-.*" emailmatchpattern "eltern-.*")
$gam loop - gam update group "~email" <<<"$parentsgroups" \
    sync manager usersonly delivery nomail users "$STUDENT_PARENTS_GROUP_MANAGERS"
parents_groupsettings=(
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
$gam loop - gam update group "~email" <<<"$parentsgroups" \
    primarylanguage de \
    replyto reply_to_sender \
    "${parents_groupsettings[@]}"

info Update all student groups configuration and managers
# For some strange reason the query also returns the elternvertreter group, filtering that out in GAM
studentgroups=$($gam print groups query "email:verteiler-.*" emailmatchpattern "verteiler-.*")
$gam loop - gam update group "~email" <<<"$studentgroups" \
    sync manager usersonly delivery nomail users "$STUDENT_PARENTS_GROUP_MANAGERS"
student_groupsettings=(
    whocandiscovergroup all_in_domain_can_discover
    whocanpostmessage all_in_domain_can_post
    whocanmoderatemembers none
    whocanmoderatecontent none
    whocanjoin invited_can_join
    whocanleavegroup none_can_leave
    whocanviewgroup all_members_can_view
    whocanviewmembership all_in_domain_can_view
)
$gam loop - gam update group "~email" <<<"$studentgroups" \
    primarylanguage de \
    replyto reply_to_sender \
    "${student_groupsettings[@]}"

