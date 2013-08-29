#!/bin/bash

s=		# source branch name
r=		# source remote name
u=		# source repo url
d=		# destination branch name
e=		# destination remote name
o=		# destination repo url
t=		# working tree

usage()
{
cat << EOF

usage: $0 $*
This script will merge branches within or across repositories.

OPTIONS:    
  Fork mode: 
    given a source remote and destination remote, 
    will fast-forward the entire fork repository.
  git-merge.sh -t <path> -r <remote> [[-u <url>]] -e <remote> [[-o <url>]]
  
  Merge mode: 
    given a source branch and destination branch, 
    will merge one branch to another.  
  git-merge.sh -t <path> -s <branch> [[-r <remote>]] [[-u <url>]] 
               -d <branch> [[-e <remote>]] [[-o <url>]] 
  
  -s Sets the source branch name.
  -r Sets the source remote name.
  -u Sets the source repository url.
  -d Sets the destination branch name.
  -e Sets the destination remote name.  
  -o Sets the destination repository url.
  -t Sets the work tree.
  -? Show this message
EOF
}

# adds or set url for a remote
# $1 IN.  name of remote
# $2 IN.  url for repository
set-remote() 
{
	if [[ -n $1 ]] && [[ -n $2 ]]
	then
		local remote=`git remote | grep "$1" `
		if [[ "$remote" == "$1" ]]
		then	
			echo # Force remote $1 to $2
			git remote set-url $1 $2
		else
			echo # Add remote $1 to $2
			git remote add $1 $2
		fi
	fi	
}

# merges a given remote/branch into another remote/branch
# $1 IN. name of source remote.
# $2 IN. name of source branch.
# $3 IN. name of destination remote.
# $4 IN. name of destination branch.
merge-branches()
{
	local remote=`git branch -r | grep "$3/$4" | grep -v HEAD `
	local exists=
	if [[ "$remote" == "  $3/$4" ]] # git branch -r prints leading spaces
	then # checkout destination branch because it exists	
		echo "# Checkout clean $3/$4"
		git checkout --force -B $4 --track $3/$4
		exists="true"
	else # checkout source branch because destination does not exist	
		echo "# Checkout clean $1/$2"
		git checkout --force -B $2 --track $1/$2
	fi	
	git clean -dff
	git pull
	
	if [[ $exists ]]
	then
		echo "# Merge from $1/$2"
		git pull $1 $2
	fi
	
	echo "# Push to $3/$4"
	git push -n --tags --recurse-submodules=on-demand $3 HEAD:$4
}

# begin arguments
while getopts "s:r:u:d:e:o:t:?" OPTION
do
	case $OPTION in
		s) s=$OPTARG ;;
		r) r=$OPTARG ;;
		u) u=$OPTARG ;;
		d) d=$OPTARG ;;
		e) e=$OPTARG ;;
		o) o=$OPTARG ;;
		t) t=$OPTARG ;;
		?) usage ; exit ;;
	 esac
done

if [[ -z $t ]] || (([[ -z $s ]] || [[ -z $d ]]) && (([[ -z $r ]] || [[ -z $e ]]) && ([[ -z $u ]] || [[ -z $o ]])))
then
	usage ; exit 1	
fi
if [[ -z $e ]]
then 
	e="origin"
fi
if [[ -z $r ]]
then
	if [[ -n $u ]]
	then r="upstream"
	else r="origin"
	fi
fi
if [[ -n $s ]] && [[ -z $d ]]
then 
	d=$s
fi
# end arguments

# begin repo init
git init $t

calldir=$PWD
cd $t
set-remote $r $u
set-remote $e $o
# end repo init

if [[ -z $s ]] || [[ -z $d ]]
then # fork mode
	echo "# Fetch all remotes"
	git fetch --all --prune --recurse-submodules
	echo "# Fast-forward fork from $r to $e"
	for remote in `git branch -r | grep $r | grep -v HEAD `
		do
		branch=${remote/$r\//}
		merge-branches $r $branch $e $branch
	done
else # merge mode
	merge-branches $r $s $e $d
fi

cd $calldir