git submodule deinit --force .
git submodule add -b master           -f -- https://github.com/danmarsden/moodle-block_attendance.git           blocks/attendance
git submodule add -b master           -f -- https://github.com/Panopto/Moodle-2.0-Plugin-for-Panopto.git        blocks/panopto
git submodule add -b master           -f -- https://github.com/sebts/moodle-grade_export_pwr.git                grade/export/pwr
git submodule add -b v0.3             -f -- https://github.com/sebts/moodle-local_adminer.git                   local/adminer
git submodule add -b master           -f -- https://github.com/danmarsden/moodle-mod_attendance.git             mod/attendance
git submodule add -b v1.0.9-SNAPSHOT  -f -- https://github.com/blindsidenetworks/moodle-mod_bigbluebuttonbn.git mod/bigbluebuttonbn
git submodule add -b MOODLE_26_STABLE -f -- https://github.com/dmonllao/moodle-mod_journal.git                  mod/journal
git submodule add -b SEBTS_26         -f -- https://github.com/sebts/moodle-mod_questionnaire.git               mod/questionnaire
git submodule add -b v1.0.9-SNAPSHOT  -f -- https://github.com/blindsidenetworks/moodle-mod_recordingsbn.git    mod/recordingsbn
git submodule add -b release          -f -- https://github.com/sebts/moodle-mod_turnitintool.git                mod/turnitintool
git submodule add -b master           -f -- https://github.com/sebts/moodle-theme_newburycollege.git            theme/newburycollege
git submodule add -b SEBTS            -f -- https://github.com/sebts/moodle-theme_zebra.git                     theme/zebra
