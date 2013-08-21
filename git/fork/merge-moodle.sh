#!/bin/sh
syncroot=/c/@/sync

git-merge.sh -t $syncroot/moodle -s MOODLE_23_STABLE -d SEBTS_23
git-merge.sh -t $syncroot/moodle-theme_zebra -s master -d SEBTS
git-merge.sh -t $syncroot/moodle-mod_questionnaire -s MOODLE_23_STABLE -d SEBTS_23
git-merge.sh -t $syncroot/moodle-mod_turnitintool -s master -d release