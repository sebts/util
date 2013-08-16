#!/bin/sh
update=/c/@/util/git/prod/moodle-update.bash
export GIT_WORK_TREE=/c/@/demo/web
export GIT_DIR=/c/@/demo/moodle.git
url=https://github.com/sebts/moodle.git
branch=SEBTS_RELEASE

echo "Backing up work tree"
mv ${GIT_WORK_TREE} ${GIT_WORK_TREE}~

echo "Cloning from Git"
git clone -b $branch $url $GIT_DIR
cd $GIT_WORK_TREE
git submodule update --init --force --recursive

echo "Copying back original tree. be patient."
cp -r ${GIT_WORK_TREE}~/* ${GIT_WORK_TREE}

echo "exclude survey files"
echo "/surveyfiles/" >> ${GIT_DIR}/info/exclude

echo "Remove unnecessary files"
find $GIT_WORK_TREE -type f \( -name "*~" -o -name "*.bak" \) -print -exec rm -f {} \;

echo "Run update script"
exec $update