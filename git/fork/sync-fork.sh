#!/bin/sh
tree=$1
# assumes origin is your fork and upstream is the parent

cd $tree

echo "# Fetch all remotes"
git fetch --all --prune

echo "# Merge each upstream branch"
for remote in `git branch -r | grep upstream | grep -v HEAD `
  do
  branch=${remote/upstream\//}
  echo "# Checkout upstream/$branch"
  git checkout --force -B $branch --track upstream/$branch
  git pull --ff-only upstream $branch
  echo "# Merge from origin/$branch"
  git pull --ff-only origin $branch
  echo "# Push updates back to origin/$branch"
  git push origin $branch --tags
done