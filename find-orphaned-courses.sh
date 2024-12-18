#!/bin/bash

source _functions.sh
# not needed source config.sh


info Find courses without owner
courses="$($gam print courses owneremailmatchpattern "Unknown user")" || : ignore errors about non-existant users

$gam loop - gam info course "~id" fields name,descriptionHeading,teachers,coursestate <<<"$courses" || : ignore errors about non-existant users


if [ "$(wc -l <<<"$courses")" -gt 1 ] ; then
    info "According to https://www.amplifiedit.com/orphaned-google-classroom-classes/ \nthere is no recovering orphaned classrooms"
    mapfile -t course_ids < <(sed -n "/@/s/,.*//p" <<<"$courses")

    echo -n "Courses: "
    echo "${course_ids[@]}" | tr " " ,
    echo 'Use "gam delete courses id,id,id..." to delete courses'
else
    echo No orphaned courses found.
fi