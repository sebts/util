#!/bin/bash
make-subtree() {
	git submodule deinit $1
	git rm $1
	git commit -m "Remove submodule $1"
	git remote add $2 $3
	git fetch $2
	git subtree add --prefix $1 $2 $4 --squash -m "Add subtree $1"
}

cd /c/@/subtree

make-subtree	admin/tool/uploadcourse \
				moodle-tool_uploadcourse \
				https://github.com/piersharding/moodle-tool_uploadcourse.git \
				"7918e33daa7840da1a57accc325326fe1846d616"

make-subtree	blocks/attendance \
				moodle-block_attendance \
				https://github.com/danmarsden/moodle-block_attendance.git \
				"0baf4769db23c3aa0b737162b1842bf1d377b926"

make-subtree	blocks/panopto \
				Moodle-2.0-Plugin-for-Panopto \
				https://github.com/Panopto/Moodle-2.0-Plugin-for-Panopto.git \
				"472027cfafcde9bb401085d0f4fb82225f5bd4e5"

make-subtree	grade/export/pwr \
				moodle-grade_export_pwr \
				https://github.com/sebts/moodle-grade_export_pwr.git \
				"aadd1c5e2f3435fd1ef295e5ef3548356db4cfa3"

make-subtree	local/adminer \
				moodle-local_adminer \
				https://github.com/sebts/moodle-local_adminer.git \
				"b5e35b12a1266d2616307766783e1e6b45a10973"

make-subtree	mod/attendance \
				moodle-mod_attendance \
				https://github.com/danmarsden/moodle-mod_attendance.git \
				"1936284948f643d26c8bf2fd2e584d26ed18da60"

make-subtree	mod/bigbluebuttonbn \
				moodle-mod_bigbluebuttonbn \
				https://github.com/blindsidenetworks/moodle-mod_bigbluebuttonbn.git \
				"c65632f238814e396c72371944ad8a893cad6c98"

make-subtree	mod/journal \
				moodle-mod_journal \
				https://github.com/dmonllao/moodle-mod_journal.git \
				"e23e15cd8d713d863e49dbb9a7ff406e55767674"

make-subtree	mod/questionnaire \
				moodle-mod_questionnaire \
				https://github.com/sebts/moodle-mod_questionnaire.git \
				"1df8d5e3be0c741da8f1db413520cc0da9f90c14"

make-subtree	mod/recordingsbn \
				moodle-mod_recordingsbn \
				https://github.com/blindsidenetworks/moodle-mod_recordingsbn.git \
				"2a61b73bc0066034583a6b145e0f759085c72f19"

make-subtree	mod/turnitintool \
				moodle-mod_turnitintool \
				https://github.com/sebts/moodle-mod_turnitintool.git \
				"4d86d4c32f6d732f3315f9b73fd12d9e99c37db2"

make-subtree	theme/newburycollege \
				moodle-theme_newburycollege \
				https://github.com/sebts/moodle-theme_newburycollege.git \
				"5505debc8ea30972c60fa785e3c03b31e84824d9"

make-subtree	theme/zebra \
				moodle-theme_zebra \
				https://github.com/sebts/moodle-theme_zebra.git \
				"ba089a92056521c65d6b7fe0f2d3b4d74de88204"