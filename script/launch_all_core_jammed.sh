#!/bin/bash

# ./launch_all.sh machine_conf/<conf> thread_conf/<conf> <core-jammer-instances>

JAMMER_INSTANCES=$3

for i in $(seq 1 ${JAMMER_INSTANCES}); do
	./utils/core-jammer &
done

./run_rand_batch_test.sh $1 tests_conf/test-0-3_7-0-3_7.conf $2	
./run_rand_batch_test.sh $1 tests_conf/test-0-3_7-0-366.conf $2	
./run_rand_batch_test.sh $1 tests_conf/test-0-366-0-366.conf $2	
./run_rand_batch_test.sh $1 tests_conf/test-0-366-0-3_7.conf $2	

killall core-jammer
