#!/bin/bash

# adds or set url for a remote
# $1 IN.  name of remote
# $2 IN.  url for repository
init-remote() 
{
	local remote=$1
	local url=$2
	
	if [[ -n $remote ]]
	then # $remote is set
		if [[ -n $url ]]
		then # $url is set
			if [[ `git remote | grep "$remote" ` == "$remote" ]]
			then # remote already set. update url.
				echo "# Force remote $remote to $url"
				git remote set-url $remote $url
			else  #remote not set. add url.
				echo "# Add remote $remote to $url"
				git remote add $remote $url
			fi
		fi
	fi	
}

# initializes a repository and sets remotes as specified
# $1 IN.  work tree for repository
# $# IN.  <remote> <url>
# you can pass in as many <name> <url> pairs as desired.
init-repository()
{
	local t=$1
	
	git init $t
	cd $t
	
	local remotes=	
	local remote=
	
	shift
	while [[ $# > 0 ]]
	do
		local split=($1)
		init-remote ${split[0]} ${split[1]}
		remotes+=" ${split[0]}"
		shift
	done
		
	remotes=$(echo "$remotes" | tr ' ' '\n' | sort -u | tr '\n' ' ') # get unique remotes
	for remote in $remotes
	do
		echo "# Fetch $remote"	
		git fetch $remote --prune --recurse-submodules
	done
}

# returns array of branches including a given search term
# $1 IN.  grep search term
# $2 OUT. returned branch array
search-branches()
{
	local search=$1
	
	# get remote branches match remote name, excluding HEAD
	local result=`git branch -r | grep -s -e "$search" | grep -v HEAD `
	
	# return an array of branches
	eval "$2=(${result})"
}

# returns true if exact branch matches 
# $1 IN.  full branch name
branch-exists()
{
	local search=$1
	local branches=
	local branch=
	search-branches $search branches
	
	for branch in "${branches[@]}"
	do
		if [[ $search == $branch ]]
			then return 0
		fi
	done
	return 1	
}

# checkout a branch with tracking remote, clean and pull.
# $1 IN.  remote name
# $2 IN.  branch name
clean-checkout()
{
	local remote=$1
	local branch=$2
	
	branch-exists $remote/$branch
	if [[ $? != 0 ]]
	then 
		echo "ERROR: git-lib/clean-checkout(). $remote/$branch does not exist and cannot be checked out!"
		exit 101
	fi
	
	echo "# Checkout clean $remote/$branch"
	git checkout --force -B $branch --track $remote/$branch
	git clean -dff
	git pull
}

# $1 IN/OUT. branch name, in <remote>/<branch> or <branch> format.
#            returned in <branch> format
# $2 OUT.    remote name, if found branch came in <remote>/<branch> format.
#            returned with parsed <remote>, or unchanged.
format-branch()
{
	local split=(${!1//\// })
	if [[ ${split[1]} ]]
	then
		eval "$2='${split[0]}'"
		eval "$1='${split[1]}'"
	fi
}

# merges a single branch to another
# $1 IN.  source remote name
# $2 IN.  source branch name
# $3 IN.  destination remote name
# $4 IN.  destination branch name
merge-branch()
{
	local sr=$1
	local sb=$2
	local dr=$3
	local db=$4

	format-branch sb sr
	format-branch db dr
	
	if [[ ! $db ]] # if no destination branch specified, use source branch
		then db=$sb
	fi
	
	branch-exists "$dr/$db"
	if [[ $? == 0 ]]
	then # destination branch exists
		clean-checkout $dr $db
		echo "# Merge from $sr/$sb"
		git pull $sr $sb
	else # destination branch does not exist
		clean-checkout $sr $sb
	fi

	echo "# Push to $dr/$db"
	git push --tags --recurse-submodules=on-demand $dr HEAD:$db
}

# loops through multiple branch merges merging source[i] into destination[i]
# $1 IN.  source remote name
# $2 IN.  source branch names
# $3 IN.  destination remote name
# $4 IN.  destination branch names
merge-branches()
{
	local sr=$1
	local sb=($2)
	local dr=$3
	local db=($4)

	if [[ -z $sb ]]
	then # no branches set. fork mode.
		echo "# Fast-forward fork from $sr to $dr"
		search-branches $sr sb #set sb to all branches for the source remote
		db= # no destination branches should be set for fork mode
	fi

	for i in "${!sb[@]}" # for loop based on length of source branch array
	do
		merge-branch $sr ${sb[i]} $dr ${db[i]}
	done
}