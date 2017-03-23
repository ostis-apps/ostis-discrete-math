#!/bin/bash

red="\e[1;31m"  # Red B
blue="\e[1;34m" # Blue B
green="\e[0;32m"

bwhite="\e[47m" # white background

rst="\e[0m"     # Text reset

update_project()
{
    if [  -d "../$1" ]; then
        echo -en $blue"Update $1$rst\n"
        cd ../$1
        git stash
		git pull
		git stash pop --quiet
        cd -
    else
        echo -en $red"You need to clone "$red"$1"$rst" first!$rst\n"
    fi
}

update_kb()
{
	if [  -d "../kb/$1" ]; then
        echo -en $blue"Update $1$rst\n"
        cd ../kb/$1
		local_branch=`git rev-parse --abbrev-ref HEAD`
        if [ $local_branch != "master" ]; then
			git stash
			git checkout master
			git pull --rebase
			git checkout $local_branch
			git rebase master
			git stash pop --quiet
		else
			git stash
			git pull --rebase
			git stash pop --quiet
		fi
        cd -
    else
        echo -en $red"You need to clone "$red"$1"$rst" first!$rst\n"
    fi
}

update_sc_machine()
{
	if [  -d "../$1" ]; then
        echo -en $blue"Update $1$rst\n"
        cd ../$1
        git pull
        cd -
		cd ../sc-machine/scripts
		./clean_all.sh
		./make_all.sh
		cd -
    else
        echo -en $red"You need to clone "$red"$1"$rst" first!$rst\n"
    fi
}

echo -en $blue"Updating projects...$rst\n"

update_sc_machine sc-machine

update_project ims.ostis.kb

update_kb gt-knowledge-processing-machine
update_kb set-theory
update_kb gt-knowledge-base

update_project gt-ostis-drawings
update_project set-ostis-drawings
update_project web-scn-editor
update_project sc-web

./update_web.sh
