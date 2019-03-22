#!/bin/bash

source ./gitmodules.sh

ROOT_FOLDER=$1

for i in `seq 0 ${#GITREPOS[*]}`; do
	if [ -d ${ROOT_FOLDER}/${GITREPOS[$i]} ]; then
		continue
	fi
	
	echo "Cloning ${GITSERVER[$i]}/${GITREPOS[$i]}.git ..."
	git clone ${GITSERVER[$i]}/${GITREPOS[$i]}.git
	if [ "$?" != "0" ]; then
		echo "An error occurs while trying to clone repo ${GITSERVER[$i]}/${GITREPOS[$i]}.git... Exit status was $?"
		exit $?
	fi
	
	cd ${GITREPOS[$i]}
	git checkout ${REFBRANCH[$i]}
	cd ..
	
	mv ${GITREPOS[$i]} ${ROOT_FOLDER}
done
