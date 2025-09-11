#!/bin/bash

source _functions.sh
# not needed source config.sh


info Find email group members where email delivery has been disabled
lines=$(
    $gam print group-members \
    showdeliverysettings \
    cachememberinfo true \
    query "email:eltern-*" \
    members \
    fields group,email,deliverysettings
)
temp_file=$(make_temp_file)
echo "$lines" >$temp_file
echo "Complete list in $temp_file"

info "Parents group members where email delivery has been disabled, e.g. due to bouncing"

grep -P '^([^,]*@([^,]*)),.*@(?!\2)[^,]*,DISABLED$' <<<"$lines" | column -t -s',' -N "== Group ==,== Email ==" -H 3 -o "    "
# ^^^-- show only external mails that are disabled, negativve lookahead for domain matching our domain email from the group domain to exclude internal members
