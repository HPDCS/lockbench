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



###################                   Generate plots             ########################

count_lines=1
count_threads=0
for i in $THREADS; do 
	if [ ! $i -gt $MACHINE_CORES ]; then
		count_lines=$(($count_lines +1))
	fi
	count_threads=$(($count_threads +1))
done


for file in ./${SRC_FOLDER}/*-TH;
do
    echo 'Plotting file '$file
     CSL=`basename $file | cut -f2 -d'-'`
     CSU=`basename $file | cut -f4 -d'-'`
    NCSL=`basename $file | cut -f6 -d'-'`
    NCSU=`basename $file | cut -f8 -d'-'`
   
	rm ./${SRC_FOLDER}/*.pdf
	rm ./${SRC_FOLDER}/*.eps
	

    gnuplot -e "xmax=\""${MAX_T}"\"" -e "tic=\""${SKIP_T}"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/plot.gp
	gnuplot -e "countlines=\""${count_lines}"\"" -e "xmax=\""$(($MACHINE_CORES+2))"\"" -e "tic=\""2"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/plot2.gp
	epstopdf $file.eps
	epstopdf $file-cores.eps
	rm $file.eps
	rm $file-cores.eps

done

cp ${SRC_FOLDER}/*.pdf ./${DST_FOLDER}/
rm ${SRC_FOLDER}/*.pdf 


###################                   Generate EN CONSUMPTION            ########################

for file in ./${SRC_FOLDER}/*-EN;
do
    echo 'Plotting file '$file
     CSL=`basename $file | cut -f2 -d'-'`
     CSU=`basename $file | cut -f4 -d'-'`
    NCSL=`basename $file | cut -f6 -d'-'`
    NCSU=`basename $file | cut -f8 -d'-'`
   
	rm ./${SRC_FOLDER}/*.pdf
	rm ./${SRC_FOLDER}/*.eps
	

    gnuplot -e "xmax=\""${MAX_T}"\"" -e "tic=\""${SKIP_T}"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/plot3.gp
	gnuplot -e "countlines=\""${count_lines}"\"" -e "xmax=\""$(($MACHINE_CORES+2))"\"" -e "tic=\""2"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/plot2.gp
	epstopdf $file.eps
	rm $file.eps

done

cp ${SRC_FOLDER}/*.pdf ./${DST_FOLDER}/
m ${SRC_FOLDER}/*.pdf 


###################                   Generate CPU plots             ########################

for file in ./${SRC_FOLDER}/*-CPU;
do
    echo 'Plotting file '$file
     CSL=`basename $file | cut -f2 -d'-'`
     CSU=`basename $file | cut -f4 -d'-'`
    NCSL=`basename $file | cut -f6 -d'-'`
    NCSU=`basename $file | cut -f8 -d'-'`
    
	rm ./${SRC_FOLDER}/*.pdf
	rm ./${SRC_FOLDER}/*.eps

	cat ./gnuplot/histo.gp 		> ./gnuplot/${MACHINE_NAME}-histo.gp
	cat ./gnuplot/histo2.gp		> ./gnuplot/${MACHINE_NAME}-histo2.gp

	count=1
	for i in $THREADS; do
		if [ $count -eq 1 ]; then
			echo  "plot newhistogram \"$i\",  filename  using (\$$(($count+1))   ):xtic(1) fs pattern 1 lc rgb \"#000000\" title \"User\",  '' using (\$$(($count+$count_threads+1)) ):xtic(1) fs pattern 3 lc rgb \"#000000\" title \"Sys\", \\" >> ./gnuplot/${MACHINE_NAME}-histo.gp
		elif [ "$count" == "$count_threads" ]; then
			echo  "newhistogram \"$i\",  filename  using (\$$(($count+1))):xtic(1) fs pattern 1 lc rgb \"#000000\" notitle,  '' using (\$$(($count+$count_threads+1))):xtic(1) fs pattern 3 lc rgb \"#000000\" notitle "							>> ./gnuplot/${MACHINE_NAME}-histo.gp
		else 
			echo  "newhistogram \"$i\",  filename  using (\$$(($count+1))):xtic(1) fs pattern 1 lc rgb \"#000000\" notitle,  '' using (\$$(($count+$count_threads+1)) ):xtic(1) fs pattern 3 lc rgb \"#000000\" notitle, \\"						>> ./gnuplot/${MACHINE_NAME}-histo.gp
		fi
		count=$(($count+1))
	done

	count=1
	for i in $THREADS; do
		if [ $count -eq 1 ]; then
			echo -n "plot newhistogram \"$i\",  filename  using (\$$(($count+1))   ):xtic(1) fs pattern 1 lc rgb \"#000000\" title \"User\",  '' using (\$$(($count+$count_threads+1)) ):xtic(1) fs pattern 3 lc rgb \"#000000\" title \"Sys\", " >> ./gnuplot/${MACHINE_NAME}-histo2.gp
		elif [ "$count" == "$(($count_lines-1))" ]; then
			echo  "newhistogram \"$i\",  filename  using (\$$(($count+1))):xtic(1) fs pattern 1 lc rgb \"#000000\" notitle,  '' using (\$$(($count+$count_threads+1)) ):xtic(1) fs pattern 3 lc rgb \"#000000\" notitle "							>> ./gnuplot/${MACHINE_NAME}-histo2.gp
			break
		else 
			echo -n "newhistogram \"$i\",  filename  using (\$$(($count+1))):xtic(1) fs pattern 1 lc rgb \"#000000\" notitle,  '' using (\$$(($count+$count_threads+1)) ):xtic(1) fs pattern 3 lc rgb \"#000000\" notitle, "						>> ./gnuplot/${MACHINE_NAME}-histo2.gp
		fi
		count=$(($count+1))
	done



    gnuplot -e "xmax=\""${MAX_T}"\"" -e "tic=\""${SKIP_T}"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/${MACHINE_NAME}-histo.gp
	gnuplot -e "xmax=\""${MAX_T}"\"" -e "tic=\""${SKIP_T}"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/${MACHINE_NAME}-histo2.gp
	
	epstopdf $file.eps
	epstopdf $file-cores.eps
	rm $file.eps
	rm $file-cores.eps
	rm ./gnuplot/${MACHINE_NAME}-histo.gp
	rm ./gnuplot/${MACHINE_NAME}-histo2.gp

done

cp ${SRC_FOLDER}/*.pdf ./${DST_FOLDER}/
rm ${SRC_FOLDER}/*.pdf 


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

	gnuplot -e "xmax=\""${MAX_T}"\"" -e "tic=\""${SKIP_T}"\"" -e "xl=\"Threads\"" -e "filename=\""$file"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$CSL"\"" -e "csu=\""$CSU"\"" -e "ncsl=\""$NCSL"\"" -e "ncsu=\""$NCSU"\"" ./gnuplot/histo3.gp
	
	epstopdf $file.eps
	rm $file.eps
	#rm $file-cores.eps
	#rm ./gnuplot/${MACHINE_NAME}-histo.gp
	#rm ./gnuplot/${MACHINE_NAME}-histo2.gp

done


cp ${SRC_FOLDER}/*.pdf ./${DST_FOLDER}/
rm ${SRC_FOLDER}/*.pdf 


