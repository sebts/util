#!/bin/bash
t=~/sync-moodle

while getopts "t:" OPTION
do
    case $OPTION in
        t) t=$OPTARG ;;
    esac
done

# moodle-theme_zebra
bash gitlib-merge -t $t/moodle-theme_zebra \
                  -u https://github.com/thedannywahl/Zebra_4_Moodle_2.git \
                  -o https://github.com/sebts/moodle-theme_zebra.git

bash gitlib-merge -t $t/moodle-theme_zebra \
                  -b master \
                  -d SEBTS_23

bash gitlib-merge -t $t/moodle-theme_zebra \
                  -b master \
                  -d SEBTS

# moodle-mod_turnitintool
bash gitlib-merge -t $t/moodle-mod_turnitintool \
                  -u https://github.com/ip-pauldawson/MoodleDirect.git \
                  -o https://github.com/sebts/moodle-mod_turnitintool.git

bash gitlib-merge -t $t/moodle-mod_turnitintool \
                  -b master \
                  -d release

# moodle-mod_questionnaire
bash gitlib-merge -t $t/moodle-mod_questionnaire \
                  -u https://github.com/remotelearner/moodle-mod_questionnaire.git \
                  -b "MOODLE_23_STABLE MOODLE_24_STABLE MOODLE_25_STABLE" \
                  -o https://github.com/sebts/moodle-mod_questionnaire.git 

bash gitlib-merge -t $t/moodle-mod_questionnaire \
                  -b "MOODLE_23_STABLE  MOODLE_24_STABLE  MOODLE_25_STABLE" \
                  -d "SEBTS_23          SEBTS_24          SEBTS_25"

# moodle
bash gitlib-merge -t $t/moodle \
                  -u https://github.com/moodle/moodle.git    \
                  -b "MOODLE_23_STABLE MOODLE_24_STABLE MOODLE_25_STABLE" \
                  -o https://github.com/sebts/moodle.git


# merge moodle core into sebts branches
bash gitlib-merge -t $t/moodle \
                  -b "MOODLE_23_STABLE  MOODLE_24_STABLE  MOODLE_25_STABLE" \
                  -d "SEBTS_23          SEBTS_24          SEBTS_25"

# update plugins/submodules
bash gitlib-submodule -t $t/moodle \
                      -b SEBTS_23
					  
bash gitlib-submodule -t $t/moodle \
                      -b SEBTS_24
					  
bash gitlib-submodule -t $t/moodle \
                      -b SEBTS_25
					  
# merge current version into release branch
# Don't do this past 23. for future versions, have production point to the version branch (SEBTS_24)
bash gitlib-merge -t $t/moodle \
                  -b "SEBTS_23" \
                  -d "SEBTS_RELEASE"
