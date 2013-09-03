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
  
  -s Sets the source branch name. Accepts a space delimited list.
  -r Sets the source remote name.
  -u Sets the source repository url.
  -d Sets the destination branch name. Accepts a space delimited list.
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
# $2 IN. name of source branch. Accepts space delimited list.
# $3 IN. name of destination remote.
# $4 IN. name of destination branch. Accepts space delimited list.
merge-branches()
{
	local sr="$1"
	local sb=($2)
	local dr="$3"
	local db=($4)
	
	for i in "${!sb[@]}"
	do	
		if [[ ! ${db[i]} ]] # if no destination branch, use source branch
			then db[i]=${sb[i]}
		fi
		
		local exists=
		if [[ `git branch -r | grep "$dr/${db[i]}" | grep -v HEAD ` == "  $dr/${db[i]}" ]] # git branch -r prints leading spaces.
		then # checkout destination branch because it exists
			echo "# Checkout clean $dr/${db[i]}"
			git checkout --force -B ${db[i]} --track "$dr/${db[i]}"
			exists="true"
		else # checkout source branch because destination does not exist	
			echo "# Checkout clean $sr/${sb[i]}"
			git checkout --force -B ${sb[i]} --track "$sr/${sb[i]}"
		fi
		
		git clean -dff
		git pull
	
		if [[ $exists ]]
		then
			echo "# Merge from $sr/${sb[i]}"
			git pull $sr ${sb[i]}
		fi

		echo "# Push to $dr/${db[i]}"
		git push --tags --recurse-submodules=on-demand $dr HEAD:${db[i]}
	done
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

echo "# Fetch all remotes"
git fetch --all --prune --recurse-submodules
# end repo init

if [[ -z $s ]]
then # fork mode
	echo "# Fast-forward fork from $r to $e"
	branches=`git branch -r | grep $r | grep -v HEAD `
	s=${branches//  $r\// }
fi

merge-branches $r "$s" $e "$d"

cd $calldir