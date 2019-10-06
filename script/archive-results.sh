#!/bin/sh

if [ "$#" != "2" ]; then
	echo 'Usage: archive-results.sh <src-folder> <dst-folder-name>'
fi

SRC_FOLDER=$1
DST_FOLDER_PREFIX=$2
DATE=$(date --utc +%y%m%dT%H%M%S)
DIRNAME=$(dirname ${SRC_FOLDER})

cp -r ${SRC_FOLDER} ${DIRNAME}/${DST_FOLDER_PREFIX}.${DATE} && tar czvf ${DIRNAME}/${DST_FOLDER_PREFIX}.${DATE}.tar.gz ${DIRNAME}/${DST_FOLDER_PREFIX}.${DATE}
rm -rf ${DIRNAME}/${DST_FOLDER_PREFIX}.${DATE}
