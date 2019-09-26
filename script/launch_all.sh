#!/bin/bash

# ./launch_all.sh machine_conf/<conf> thread_conf/<conf>

./run_rand_batch_test.sh $1 tests_conf/test-0-3_7-0-3_7.conf $2	
./run_rand_batch_test.sh $1 tests_conf/test-0-3_7-0-366.conf $2	
./run_rand_batch_test.sh $1 tests_conf/test-0-366-0-366.conf $2	
./run_rand_batch_test.sh $1 tests_conf/test-0-366-0-3_7.conf $2	