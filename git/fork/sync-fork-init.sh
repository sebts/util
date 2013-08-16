#!/bin/sh
fork=$1   #git address for your fork repo
parent=$2 #git address for parent repo
tree=$3   #local directory for clone

echo "# Clone $fork into $tree"
git clone -n $fork $tree
cd $tree

echo "# Add upstream for $parent"
git remote add upstream $parent