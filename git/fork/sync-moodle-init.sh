#!/bin/sh
syncroot=/c/@/sync

sync-fork-init.sh $syncroot/moodle https://github.com/sebts/moodle.git https://github.com/moodle/moodle.git

sync-fork-init.sh $syncroot/moodle-theme_zebra https://github.com/sebts/moodle-theme_zebra.git https://github.com/thedannywahl/Zebra_4_Moodle_2.git 

sync-fork-init.sh $syncroot/moodle-mod_turnitintool https://github.com/sebts/moodle-mod_turnitintool.git https://github.com/ip-pauldawson/MoodleDirect.git 

sync-fork-init.sh $syncroot/moodle-mod_questionnaire https://github.com/sebts/moodle-mod_questionnaire.git https://github.com/remotelearner/moodle-mod_questionnaire.git