#!/bin/sh

t= #local tree directory
r= #remote
b= #branch
i= #initialize flag

# begin arguments
while getopts "t:r:b:i?" OPTION
do
	case $OPTION in
		t) t=$OPTARG ;;
		r) r=$OPTARG ;;
		b) b=$OPTARG ;;
		i) i="true" ;;
		?) usage ; exit ;;
	 esac
done

#super-tree
#super-remote
#super-branch
#if we assume that we are already on the right superbranch, then the above are not necessary. This would greatly reduce the params.
#sub-tree
#sub-remote?
#sub-branch
#

#cd $t
#git checkout --force -B ${branch} --track "${remote}/${branch}"
#git clean -dff
#git pull
#git submodule sync
#git submodule update --init --recursive
#cd $sub
#git checkout --force -B ${sub-branch} --track origin/${sub-branch}
#git clean -dff
#git pull
#show=`git show --oneline `
#cd $t
#git add $sub
#git commit -m "Updating $sub to $show"
#git push