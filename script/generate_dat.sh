#!/bin/bash
set -e

# $1 confing_test
# $2 confing_machine



source  ./$1
source  ./$2
source  ./$3
source tests_conf/lock_selection.conf


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

SRC_FOLDER="../out/${MACHINE_NAME}-out-$FOLDER/dat"
DST_FOLDER="../out/${MACHINE_NAME}-out-$FOLDER/dat-aggregated"

if [ ! -d ../out ]; then
	echo "Aggregating data..."
	./utils/aggregate_rand_batch_test.sh $1 $2
	echo "DONE!"
fi

mkdir -p $DST_FOLDER



# CREATE THROUGHPUT DAT
out_filename="$DST_FOLDER/csl-$LOWER_RANGE_CS-csu-$UPPER_RANGE_CS-ncsl-$LOWER_RANGE_NCS-ncsu-$UPPER_RANGE_NCS"
rm -f $out_filename-TH
line="THREADS"


# CREATE THROUGHPUT HEADER
for l in $LOCKS; do
	for sws in "1"; do
		line="$line $l-$sws"
	done
done

echo $line > $out_filename-TH
echo $line > $out_filename-EN
echo $out_filename-TH


# CREATE THROUGHPUT DAT LINES

for t in $THREADS; do
	line="$t"
	for l in $LOCKS; do
		for sws in "1"; do
			in_filename="$SRC_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t-STATS"
			val=`tail -n1 $in_filename-TH | cut -f3 -d','`
			line="$line $val"
			done
	done
	echo $line >> $out_filename-TH
done


for t in $THREADS; do
	line="$t"
	for l in $LOCKS; do
		for sws in "1"; do
			in_filename="$SRC_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t-STATS"
			val=`tail -n1 $in_filename-EN | cut -f3 -d','`
			line="$line $val"
			done
	done
	echo $line >> $out_filename-EN
done



# CREATE CPU DAT
rm -f $out_filename-CPU
line="THREADS"


# CREATE CPU HEADER
for l in $LOCKS; do
	for sws in "1"; do
		line="$line $l-$sws-UT"
		line="$line $l-$sws-ST"
	done
done


echo $line > $out_filename-CPU
echo $out_filename-CPU


# CREATE CPU DAT LINES
for t in $THREADS; do
	line="$t"
	for l in $LOCKS; do
		for sws in "1"; do
			in_filename="$SRC_FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t-STATS"
			val=`tail -n1 $in_filename-UT | cut -f3 -d','`
			line="$line $val"
			val=`tail -n1 $in_filename-ST | cut -f3 -d','`
			line="$line $val"
			done
	done
	echo $line >> $out_filename-CPU
done



awk -f utils/transpose.awk $out_filename-CPU > $out_filename-CPU-TRANSPOSED

echo "#"`head -n 1 $out_filename-CPU-TRANSPOSED` 				> $out_filename-CPU-FINAL-UT
echo `head -n 1 $out_filename-CPU-TRANSPOSED | cut -f 2- -d' '` > $out_filename-CPU-FINAL-ST

grep -- '-UT' $out_filename-CPU-TRANSPOSED 						>> $out_filename-CPU-FINAL-UT
grep -- '-ST' $out_filename-CPU-TRANSPOSED | cut -f 2- -d' ' 	>> $out_filename-CPU-FINAL-ST

sed -i 's/-UT//g' $out_filename-CPU-FINAL-UT

paste $out_filename-CPU-FINAL-UT $out_filename-CPU-FINAL-ST > $out_filename-CPU

rm $out_filename-CPU-FINAL-UT $out_filename-CPU-FINAL-ST $out_filename-CPU-TRANSPOSED


sed -i 's/-1//g' $out_filename-CPU
sed -i 's/-1//g' $out_filename-TH
sed -i 's/-1//g' $out_filename-EN
sed -i 's/_/-/g' $out_filename-CPU
sed -i 's/_/-/g' $out_filename-TH
sed -i 's/_/-/g' $out_filename-EN


python utils/averages.py $out_filename-TH $MACHINE_CORES
python utils/compute_en_th.py $out_filename-EN $out_filename-TH > $out_filename-ENTH

