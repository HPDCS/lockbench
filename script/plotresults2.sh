#!/bin/bash


# $1 confing_test
# $2 confing_machine


source  ./$1
source  ./$2
source  ./$3

for i in `seq 0 ${#VALUES[*]}`; do
	if [ $LOWER_RANGE_CS = ${VALUES[$i]} ] ; then
		LOWER_RANGE_CS_TS=${TRANSLATE[$i]}
		break
	fi
done

for i in `seq 0 ${#VALUES[*]}`; do
	if [ $UPPER_RANGE_CS = ${VALUES[$i]} ] ; then
		UPPER_RANGE_CS_TS=${TRANSLATE[$i]}
		break
	fi
done

for i in `seq 0 ${#VALUES[*]}`; do
	if [ $LOWER_RANGE_NCS = ${VALUES[$i]} ] ; then
		LOWER_RANGE_NCS_TS=${TRANSLATE[$i]}
		break
	fi
done

for i in `seq 0 ${#VALUES[*]}`; do
	if [ $UPPER_RANGE_NCS = ${VALUES[$i]} ] ; then
		UPPER_RANGE_NCS_TS=${TRANSLATE[$i]}
		break
	fi
done


FOLDER="batch_res_${LOWER_RANGE_CS}_${UPPER_RANGE_CS}_${LOWER_RANGE_NCS}_${UPPER_RANGE_NCS}"

SRC_FOLDER="../out/${MACHINE_NAME}-out-$FOLDER/dat-aggregated"
DST_FOLDER="../plots/${MACHINE_NAME}-out-$FOLDER"
mkdir -p $DST_FOLDER

SKIP_T="8"
SKIP_S="1"

MAX_T="$((MACHINE_CORES*2))"
MAX_S="61"


###################                   Generate CPU plots             ########################

for file in ./${SRC_FOLDER}/*-AVG;
do
    echo 'Plotting file '$file
     CSL=`basename $file | cut -f2 -d'-'`
     CSU=`basename $file | cut -f4 -d'-'`
    NCSL=`basename $file | cut -f6 -d'-'`
    NCSU=`basename $file | cut -f8 -d'-'`
    
	rm ./${SRC_FOLDER}/*.pdf
	rm ./${SRC_FOLDER}/*.eps

	echo $file
	gnuplot -e "xmax=\""${MAX_T}"\"" -e "tic=\""${SKIP_T}"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/histo-new.gp
	
	epstopdf $file-NO-TIMESHARING.eps
	epstopdf $file-TIMESHARING.eps
	epstopdf $file-OVERALL.eps
	rm $file-NO-TIMESHARING.eps
	rm $file-TIMESHARING.eps
	rm $file-OVERALL.eps
	#rm $file-cores.eps
	#rm ./gnuplot/${MACHINE_NAME}-histo.gp
	#rm ./gnuplot/${MACHINE_NAME}-histo2.gp
	break

done


cp ${SRC_FOLDER}/*.pdf ./${DST_FOLDER}/
rm ${SRC_FOLDER}/*.pdf 


