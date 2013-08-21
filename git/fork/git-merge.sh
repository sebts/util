#!/bin/bash

#USAGE
usage()
{
cat << EOF
usage: $0 options

This script will merge two branches within an existing repository.

OPTIONS:
  merge.sh -s <remote>/<branch> -d <remote>/<branch> [-t /path/to/tree]
  
  -s Sets the source branch for the merge.	 
  -d Sets the destination branch for the merge. 	 
  -t Sets the work tree for the local repository. Default: PWD.
  -? Show this message
EOF
}

s=
sb=
sr=
d=
db=
dr=
t=

#ARGS
while getopts "s:d:t:?" OPTION
do
	case $OPTION in
		s)	
			s=$OPTARG
			args=(${s//\// })
			if [[ -n ${args[1]} ]]
			then
				sr=${args[0]}
				sb=${args[1]}
			else
				sb=$s
			fi
			;;
		d)
			d=$OPTARG
			args=(${d//\// })
			if [[ -n ${args[1]} ]]
			then
				dr=${args[0]}
				db=${args[1]}
			else
				sb=$s
			fi
			;;
		t)
			t=$OPTARG
			;;
		?)
			usage
			exit
			;;
	 esac
done

if [[ -z $t ]]
then
	t=$PWD
fi

if [[ -z $sr ]] || [[ -z $sb ]] || [[ -z $dr ]] || [[ -z $db ]] || [[ -z $t ]]
then
	usage
	exit 1
fi

#MERGE
cd $t
echo "# Checkout $s to $t"
git checkout --force -B $sb --track $s
git pull --ff-only $sr $sb
echo "# Merge from $d"
git pull $dr $db
echo "# Push to $d"
git push -n $dr $db --tags
