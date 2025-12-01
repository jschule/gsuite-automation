#!/bin/bash

source _functions.sh
source config.sh

oldowner="${1:-}"
newowner="${2:-$DATA_TRANSFER_RECIPIENT}"
test "$oldowner" -a "$newowner" || die "Usage: $0 <old owner> [new owner, default: $DATA_TRANSFER_RECIPIENT]"

$gam info user "$oldowner" quick fields fullname || die "Please specify valid old owner"

$gam info user "$newowner" quick fields fullname || die "Please specify valid new owner"

info "Find courses owned by >$oldowner< and assigning to >$newowner<"

courses="$($gam print courses owneremailmatchpattern "$oldowner")" || : ignore errors about non-existant users

$gam loop - gam info course "~id" fields name,descriptionHeading,teachers <<<"$courses" || : ignore errors about non-existant users

course_count="$(wc -l <<<"$courses")"
# always have line with column headings, so count is one less
let course_count--
if [ "$course_count" -gt 0 ] ; then
    # courses have @ and we strip off everything after the id in the first column
    mapfile -t course_ids < <(sed -n "/@/s/,.*//p" <<<"$courses")

    echo -n "Courses: "
    echo "${course_ids[@]}" | tr " " ,

    $gam loop - gam update course "~id" teacher "$newowner" <<<"$courses"
else
    info "No courses found"
fi