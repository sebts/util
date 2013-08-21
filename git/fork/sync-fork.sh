#!/bin/sh
tree=$1
scripts=${PWD}
# assumes origin is your fork and upstream is the parent


cd $tree

echo "# Fetch all remotes"
git fetch --all --prune

echo "# Merge each upstream branch"
for remote in `git branch -r | grep upstream | grep -v HEAD `
  do
  branch=${remote/upstream\//}
  $scripts/git-merge.sh -s upstream/$branch -d origin/$branch
done