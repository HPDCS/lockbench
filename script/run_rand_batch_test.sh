#!/bin/bash

# $1 confing_test
# $2 confing_machine

MAX_RETRY="5"



source  $1
source  $2
source  $3



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
FOLDER_PREFIX="${MACHINE_NAME}-dat-"
FOLDER=../dat/${FOLDER_PREFIX}$FOLDER
mkdir -p $FOLDER



exec_test ()
{
	N=0
	if [ $OVERWRITE = "1" ] ; then
		echo "" > $2
	fi
	echo $cmd_line 
	while [ ! -f $2 ] || [ $(grep -c "Throughput:" $2) -eq 0 ]
	do
		{ timeout $((TEST_DURATION * 2)) /usr/bin/time -f'%U %S' $cmd_line; } &> $2
		if test $N -ge $MAX_RETRY ; then echo break; break; fi
		N=$(( N+1 ))
	done
	cat $2
}





count=0

c1=0
c2=0
c3=0
for r in $NRUN; do
	c1=`echo $c1+1 | bc`	
done

for t in $THREADS; do
	c2=`echo $c2+1 | bc`
done

for l in $LOCKS; do
	#if [ $i = 2 ] || [ $i = 5 ] || [ $i = 10 ] || [ $i = 12 ]; then
	#	for sws in $SPIN_WINDOWS; do
	#	count=`echo $count+1 | bc`
	#	done
	#else
		c3=`echo $c3+1 | bc`
	#fi
done
count=`echo $c3*$c2*$c1 | bc`

echo "Expected test duration: " `echo $count*${TEST_DURATION}/60 | bc` " minutes."
#read -p "Press any key to continue... " -n1 -s
echo ""

for r in $NRUN; do
	for t in $THREADS; do
		for l in $LOCKS; do
			for sws in "1"; do
				cmd_line="../liblitl/lib$l.sh ../bin/test-PTHREAD_MUTEX_LOCK -s $sws -rnd_cs_lower $LOWER_RANGE_CS_TS -rnd_cs_higher $UPPER_RANGE_CS_TS -rnd_ncs_lower $LOWER_RANGE_NCS_TS -rnd_ncs_higher $UPPER_RANGE_NCS_TS -t $t -l $TEST_DURATION -trace"
				filename="$FOLDER/$l-win-$sws-csl-$LOWER_RANGE_CS_TS-csu-$UPPER_RANGE_CS_TS-ncsl-$LOWER_RANGE_NCS_TS-ncsu-$UPPER_RANGE_NCS_TS-T-$t-R-$r"
				exec_test $l $filename $sws
			done
		done
	done
done

