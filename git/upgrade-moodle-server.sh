#!/bin/bash

b= #branch name
t="/usr/share/moodle" #git working tree. also the production directory
d="/var/lib/moodle.git" #git repository directory.
u="https://github.com/sebts/moodle.git" #repository url
m=true
w=0
i=false
s="www-data"

usage()
{
cat << EOF

$0 $*
This script will update a moodle installation via using git.

OPTIONS:

  $0 -b <branch> [-t <path>] [-d <path>] [-u <url>] [-m <bool> [-w <int>] [-i <bool>] [-s <user>]

  -b Sets the branch name to pull from git.
  -t Sets the work tree, i.e., production directory. Default: "/usr/share/moodle"
  -d Sets the git directory. Default: "/var/lib/moodle.git"
  -u Sets the repository url. Default: "https://github.com/sebts/moodle.git"
  -m Sets moodle maintenance mode. Default: true
  -w Sets the number of minutes to warn moodle users before running update. Default: 0
  -i Sets interactive mode for moodle upgrade. Default: false
  -s Sets su for moodle cli. Default: "www-data"
EOF
}

# begin arguments
while getopts "b:t:d:u:m:w:i:s:" OPTION
do
    case $OPTION in
        b) b=$OPTARG ;;
        t) t=$OPTARG ;;
        d) d=$OPTARG ;;
        u) u=$OPTARG ;;
        m) m=$OPTARG ;;
        w) w=$OPTARG ;;
        i) i=$OPTARG ;;
        s) s=$OPTARG ;;
        ?) usage ; exit ;;
     esac
done

if [[ -z $b ]] || [[ -z $t ]] || [[ -z $d ]] || [[ -z $u ]] || [[ -z $m ]] || [[ -z $w ]] || [[ -z $i ]] || [[ -z $s ]]
then
    usage ; exit 1;
fi
# end arguments

if [[ -d $t ]] # if moodle dir exists
then

    calldir="$PWD"
    cd "$t"
    git fetch origin
    if [[ $(git rev-parse HEAD) == $(git rev-parse @{u}) ]] &&
       [[ -z $(git status --porcelain) ]]
        then
        echo "Everything is up-to-date. Thank you and good night."
        exit 0;
    fi
    cd "$calldir"

    if [[ $m == true ]]
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
fi

# Update from git
bash gitlib-update -t $t -d $d -u $u -b $b

# Always upgrade moodle database. Even if we didn't put moodle in maintenance mode
# it's better to run the upgrade script while moodle is running than to accidentally *need* to run it, but fail to.
[[ $i == true ]] || uparg="--non-interactive"
sudo -u $s /usr/bin/php $t/admin/cli/upgrade.php $uparg
sudo -u $s /usr/bin/php $t/admin/cli/maintenance.php --disable # re-open
