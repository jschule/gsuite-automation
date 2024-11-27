#!/bin/bash

source _functions.sh
# not needed source config.sh


info Find email group members where email delivery has been disabled
$gam print group-members \
    showdeliverysettings cachememberinfo true \
    fields email,deliverysettings \
        | grep -P '^([^,]*@([^,]*)),.*@(?!\2)[^,]*,DISABLED$'
        # ^^^-- show only external mails that are disabled, matching our domain email from the group domain
