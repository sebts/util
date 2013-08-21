#!/bin/sh
tree=$1   #local working tree for repo
fork=$2   #git url for your fork repo
parent=$3 #git url for parent repo

echo "# Clone $fork into $tree"
git clone -n $fork $tree
cd $tree

echo "# Add upstream for $parent"
git remote add upstream $parent