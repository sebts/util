#!/bin/bash

b= #branch name
t="/usr/share/moodle" #git working tree. also the production directory
d="/var/lib/moodle.git" #git repository directory.
u="https://github.com/sebts/moodle.git" #repository url
w=0
i=true
s="www-data"

usage()
{
cat << EOF

$0 $*
This script will update a moodle installation via using git.

OPTIONS:
  
  $0 -b <branch> [-t <path>] [-d <path>] [-u <url>] [-w <int>] [-i <bool>] [-s <user>]

  -b Sets the branch name to pull from git.
  -t Sets the work tree, i.e., production directory. Default: "/usr/share/moodle"
  -d Sets the git directory. Default: "/var/lib/moodle.git"
  -u Sets the repository url. Default: "https://github.com/sebts/moodle.git"
  -w Sets the number of minutes to warn moodle users before running update. Default: 0
  -i Sets interactive mode for moodle upgrade. Default: true
  -s Sets su for moodle cli. Default: "www-data"
EOF
}

# begin arguments
while getopts "b:t:d:u:w:i" OPTION
do
    case $OPTION in
        b) b=$OPTARG ;;
        t) t=$OPTARG ;;
        d) d=$OPTARG ;;
        u) u=$OPTARG ;;
        w) w=$OPTARG ;;
        i) i=$OPTARG ;;
        ?) usage ; exit ;;
     esac
done

if [[ -z $t ]] || [[ -z $d ]] || [[ -z $u ]] || [[ -z $b ]]
then
    usage ; exit 1;
fi
# end arguments

if  [[ -d $t ]] # if moodle exists, put it in maintenance mode
then
	# Moodle maintenance mode
	if [[ $w > 0 ]]
	then
		# warn users prior to maintenance
		sudo -u $s /usr/bin/php $t/admin/cli/maintenance.php --enablelater=${w} 
		sleep ${w}m # wait for maintenance window
	fi
	# always force maintenance in case timing is off
	sudo -u $s /usr/bin/php $t/admin/cli/maintenance.php --enable
fi

# Update from git
bash gitlib-update  -t $t -d $d -u $u -b $b

# Upgrade moodle database
[[ $i ]] || uparg="--non-interactive"
sudo -u $s /usr/bin/php $t/admin/cli/upgrade.php $uparg

# All done
sudo -u $s /usr/bin/php $t/admin/cli/maintenance.php --disable # re-open
