#!/bin/bash
t=~/sync-moodle

while getopts "t:" OPTION
do
	case $OPTION in
		t) t=$OPTARG ;;
	esac
done

# moodle-theme_zebra
git-merge.sh 	-t $t/moodle-theme_zebra \
				-u https://github.com/thedannywahl/Zebra_4_Moodle_2.git	\
				-o https://github.com/sebts/moodle-theme_zebra.git

git-merge.sh	-t $t/moodle-theme_zebra \
				-b master \
				-d SEBTS

# moodle-mod_turnitintool
git-merge.sh 	-t $t/moodle-mod_turnitintool \
				-u https://github.com/ip-pauldawson/MoodleDirect.git \
				-o https://github.com/sebts/moodle-mod_turnitintool.git

git-merge.sh	-t $t/moodle-mod_turnitintool \
				-b master \
				-d release
				
# moodle-mod_questionnaire
git-merge.sh 	-t $t/moodle-mod_questionnaire \
				-u https://github.com/remotelearner/moodle-mod_questionnaire.git \
				-b "MOODLE_23_STABLE MOODLE_24_STABLE MOODLE_25_STABLE" \
				-o https://github.com/sebts/moodle-mod_questionnaire.git 

git-merge.sh	-t $t/moodle-mod_questionnaire \
				-b MOODLE_23_STABLE \
				-d SEBTS_23

# moodle
git-merge.sh	-t $t/moodle \
				-u https://github.com/moodle/moodle.git	\
				-b "MOODLE_23_STABLE MOODLE_24_STABLE MOODLE_25_STABLE" \
				-o https://github.com/sebts/moodle.git

git-merge.sh	-t $t/moodle \
				-b MOODLE_23_STABLE \
				-d SEBTS_23
				
git-submodule.sh	-t $t/moodle \
					-b SEBTS_23