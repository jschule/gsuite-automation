#!/bin/bash

source _functions.sh
source config.sh


info Find courses without owner
courses="$($gam print courses owneremailmatchpattern "Unknown user")" || : ignore errors about non-existant users

$gam loop - gam info course "~id" fields name,descriptionHeading,teachers <<<"$courses" || : ignore errors about non-existant users

info "According to https://www.amplifiedit.com/orphaned-google-classroom-classes/ \nthere is no recovering orphaned classrooms"


if [ "$(wc -l <<<"$courses")" -gt 0 ] ; then
    mapfile -t course_ids < <(sed -n "/@/s/,.*//p" <<<"$courses")

    echo -n "Courses: "
    echo "${course_ids[@]}" | tr " " ,
fi