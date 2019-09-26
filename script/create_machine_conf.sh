#!/bin/bash

ITERATIONS="10"

cd utils
make

sum=0
for i in 1 2 3 4 5 6 7 8 9 0; do
	val=`./looper2  --runs 20 --timeout 50000 | cut -f6 -d' '`
	sum=`echo $val+$sum | bc`
done
result=`echo $sum/$ITERATIONS | bc`
echo OLD LOOPER $result

sum=0
for i in 1 2 3 4 5 6 7 8 9 0; do
	val=`./looper  --runs 20 --timeout 50000 | cut -f6 -d' '`
	sum=`echo $val+$sum | bc`
done
result=`echo $sum/$ITERATIONS | bc`
echo NEW LOOPER $result

make clean
cd ..

val=`../bin/test-PTHREAD_MUTEX_LOCK  -s 1 -rnd_cs_lower 100000 -rnd_cs_higher 100000 -rnd_ncs_lower 0 -rnd_ncs_higher 0 -t 1 -seq | grep CS/sec`
val=`python -c "print '$val'.strip().split(' ')[-1]"` 
result=`echo 100000/$val | bc`
echo LAST LOOPER $result

cpu=`lscpu | grep "Model name"`
cpucount=`lscpu | grep "CPU(s):"|head -n1`
vendor=`lscpu | grep "Vendor ID"`


cpu=`python -c "print '$cpu'.split(':')[1]"`
cpucount=`python -c "print '$cpucount'.split(':')[1].replace(' ', '')"`
vendor=`python -c "print '$vendor'.split(':')[1].replace(' ', '')"`
cpu_label=$cpu
cpu_label=`python -c "print '$cpu_label'.replace('Intel(R) ', '').replace('Xeon(R)', '').replace('Core(TM)', '').replace('CPU', '').replace(' ', '').split('@')[0]"`
cpu_label=`python -c "print '$cpu_label'.replace('(tm)', '').replace('AMD', '').replace('Processor', '-').replace(' ', '')"`

python -c "print '$cpu_label'"
python -c "print '$cpucount'"
python -c "print '$vendor'"


distro=`lsb_release -a | grep Descr`
distro=`python -c "print '$distro'.split(':')[1].strip()"`


file="machine_conf/`uname -n`.conf"


if test -f "$file"; then
    echo "$file exist"
    exit
fi


echo "MACHINE_NAME=\"$vendor\""						> $file
echo "MACHINE_CORES=\"$cpucount\""					>>$file
echo "KERNEL_V=\"`uname -s` `uname -r`\""			>>$file
echo "HOSTNAME=\"`uname -n`\""						>>$file
echo "DISTRO=\"$distro\""		>>$file
echo "GCC_V=\"`gcc --version | head -n1`\""			>>$file
echo "GLIBC_V=\"`getconf GNU_LIBC_VERSION`\""		>>$file
echo ""												>>$file
echo "LOOPS_PER_US=\"$result\""						>>$file
echo ""												>>$file
echo "VALUES[0]=\"0.5\""							>>$file
echo "VALUES[1]=\"366\""							>>$file
echo "VALUES[2]=\"0\""								>>$file
echo "VALUES[3]=\"3.7\""							>>$file
echo "VALUES[4]=\"180\""							>>$file
echo "VALUES[5]=\"732\""							>>$file
echo ""												>>$file
echo "TRANSLATE[0]=\"`echo $result*0.5/1 | bc`\""		>>$file
echo "TRANSLATE[1]=\"`echo $result*366/1 | bc`\""		>>$file
echo "TRANSLATE[2]=\"`echo $result*0  /1 | bc`\""		>>$file
echo "TRANSLATE[3]=\"`echo $result*3.7/1 | bc`\""		>>$file
echo "TRANSLATE[4]=\"`echo $result*180/1 | bc`\""		>>$file
echo "TRANSLATE[5]=\"`echo $result*732/1 | bc`\""		>>$file






