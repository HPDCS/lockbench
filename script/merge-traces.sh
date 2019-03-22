source  $1
source  $2
source  $3


#LOCKS="NSS_MUTLOCK_LOCK" 
#LOCKS="THC1_MUTLOCK_LOCK" 
LOCKS="NSS_MUTLOCK_LOCK THC1_MUTLOCK_LOCK NSS2_MUTLOCK_LOCK THC12_MUTLOCK_LOCK"





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


#FOLDER="batch_res_${LOWER_RANGE_CS}_${UPPER_RANGE_CS}_${LOWER_RANGE_NCS}_${UPPER_RANGE_NCS}"
#FOLDER_PREFIX="${MACHINE_NAME}-dat-"
#FOLDER=../dat/${FOLDER_PREFIX}$FOLDER
FOLDER=../trace
mkdir -p $FOLDER




for l in $LOCKS; do
	for t in $THREADS; do
		for sws in "1"; do
			ofilename="$FOLDER-merge/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t"
			echo -n "" > $ofilename
			for r in $NRUN; do
				filename="$FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t-R-$r"
				echo $filename
				len=`wc -l $filename | cut -d' ' -f1`
				#echo $len
				cat $filename | tail -n$(($len-2)) | head -n$(($len-3)) >> $ofilename
				echo "" >> $ofilename
				echo "" >> $ofilename
				echo "" >> $ofilename
				echo "" >> $ofilename
			done 
		done
	done
done

mkdir -p "$FOLDER-merge-pdf"

for l in $LOCKS; do
	for t in $THREADS; do
		for sws in "1"; do
			ofilename="$FOLDER-merge/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t"
		    gnuplot -e "xmax=\""${MAX_T}"\"" -e "tic=\""$t"\"" -e "xl=\"Time (CS=100)\"" -e "filename=\""$ofilename"\"" -e "cores=\"${MACHINE_CORES}\"" -e "machine=\"${MACHINE_NAME}\"" -e "csl=\""$LOWER_RANGE_CS"\"" -e "csu=\""$UPPER_RANGE_CS"\"" -e "ncsl=\""$LOWER_RANGE_NCS"\"" -e "ncsu=\""$UPPER_RANGE_NCS"\"" ./gnuplot/trace.gp
		    epstopdf $ofilename.eps
		    rm $ofilename.eps
		    echo $ofilename
		    cp $ofilename.pdf "$FOLDER-merge-pdf/"
			rm $ofilename.pdf
		done
	done
done


for l in $LOCKS; do
	acc=""
	for t in $THREADS; do
		for sws in "1"; do
			ofilename="$FOLDER-merge-pdf/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t.pdf"
			acc=" $acc $ofilename"
		done
	done
	pdfjoin $acc -o $l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-join.pdf
done



