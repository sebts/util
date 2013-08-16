#!/bin/sh
export GIT_WORK_TREE=/c/@/demo/web
export GIT_DIR=/c/@/demo/moodle.git
branch=SEBTS_RELEASE

cd $GIT_WORK_TREE

echo "Ensure correct branch"
git checkout --force $branch

echo "Clean any rogue edits"
reset="git reset --hard"
clean="git clean -d --force"
$reset && $clean
git submodule foreach --recursive "$reset && $clean"

echo "Pull current code"
git pull
git submodule update --recursive --init --force