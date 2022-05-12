#!/bin/bash
set -e

# ./launch_all.sh machine_conf/<conf> thread_conf/<conf>

do_job(){
./utils/aggregate_rand_batch_test.sh $1 $2 $3
./generate_dat.sh $1 $2 $3
#./plotresults.sh $1 $2 $3
}

do_job $1 tests_conf/test-0-3_7-0-3_7.conf $2	
do_job $1 tests_conf/test-0-3_7-0-366.conf $2	
do_job $1 tests_conf/test-0-366-0-366.conf $2	
do_job $1 tests_conf/test-0-366-0-3_7.conf $2	
do_job $1 tests_conf/test-0-36-0-36.conf   $2   

wait
