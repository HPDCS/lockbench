#!/bin/bash

# GENERATE FILES CONTAINING ONE LINE FOR EACH EXECUTION
# GENERATE FILES CONTAINING AGGREGATED STATISTICS


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

SRC_FOLDER="../dat/${MACHINE_NAME}-dat-$FOLDER"
DST_FOLDER="../out/${MACHINE_NAME}-out-$FOLDER/dat"
mkdir -p $DST_FOLDER



# THIS REMOVES MULTILINE FILES 
for t in $THREADS; do
	for l in $LOCKS; do
		for sws in "1"; do
			out_filename="$DST_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t"
			rm -f $out_filename-TH-STATS $out_filename-ST-STATS $out_filename-UT-STATS
		done
	done
done

# THIS AGGREGATES RUNS IN A UNIQUE MULTILINE FILE
for t in $THREADS; do
	for l in $LOCKS; do
		for r in $NRUN; do
			for sws in "1"; do
				in_filename="$SRC_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t-R-$r"
				out_filename="$DST_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t"
				touch $out_filename-TH
				touch $out_filename-ST
				touch $out_filename-UT
				grep "Throughput" $in_filename | head -n 1  | cut -f4 -d' ' >> $out_filename-TH
				tail -n 1 $in_filename | cut -f1 -d' ' >> $out_filename-UT
				tail -n 1 $in_filename | cut -f2 -d' ' >> $out_filename-ST
			done
		done
	done
done


# THIS COMPUTES STATISTICS IN A NEW FILE
for t in $THREADS; do
	for l in $LOCKS; do
		for sws in "1"; do
			in_filename="$DST_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t"
			out_filename="$DST_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t-STATS"
			echo "COUNT,SUM,AVG,STDV" > $out_filename-TH
			count=`wc -l $in_filename-TH | cut -f1 -d' '`
			
			str=""
			sum=0
			while read p; do
			  str="$str $p"
			  sum=`echo $sum + $p | bc`
			done < $in_filename-TH
			avg=`echo $sum/$count | bc`
			
			ssum=0
			while read p; do
			  sq=`echo $p - $avg   | bc`
			  ssum=`echo $ssum + $sq ^ 2  | bc`
			  stdv=`echo $ssum / $count  | bc`
			  stdv=`echo "sqrt ( $stdv )"  | bc`
			done < $in_filename-TH
			
			echo $count,$sum,$avg,$stdv >> $out_filename-TH

			###################################################
			
			echo "COUNT,SUM,AVG,STDV" > $out_filename-UT
			count=`wc -l $in_filename-UT | cut -f1 -d' '`
			str=""
			sum=0
			while read p; do
			  str="$str $p"
			  sum=`echo $sum + $p | bc`
			done < $in_filename-UT
			avg=`echo $sum/$count | bc`
			
			ssum=0
			while read p; do
			  sq=`echo $p - $avg   | bc`
			  ssum=`echo $ssum + $sq ^ 2  | bc`
			  stdv=`echo $ssum / $count  | bc`
			  stdv=`echo "sqrt ( $stdv )"  | bc`
			done < $in_filename-UT
			
			echo $count,$sum,$avg,$stdv >> $out_filename-UT
			
			###################################################
			
			echo "COUNT,SUM,AVG,STDV" > $out_filename-ST
			count=`wc -l $in_filename-ST | cut -f1 -d' '`
			str=""
			sum=0
			while read p; do
			  str="$str $p"
			  sum=`echo $sum + $p | bc`
			done < $in_filename-ST
			avg=`echo $sum/$count | bc`
			
			ssum=0
			while read p; do
			  sq=`echo $p - $avg   | bc`
			  ssum=`echo $ssum + $sq ^ 2  | bc`
			  stdv=`echo $ssum / $count  | bc`
			  stdv=`echo "sqrt ( $stdv )"  | bc`
			done < $in_filename-ST
			
			echo $count,$sum,$avg,$stdv >> $out_filename-ST
		done
	done
done


# CLEAN FILES AGAIN
for t in $THREADS; do
	for l in $LOCKS; do
		for sws in "1"; do
			out_filename="$DST_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t"
			rm -f $out_filename-TH
			rm -f $out_filename-ST
			rm -f $out_filename-UT
		done
	done
done

