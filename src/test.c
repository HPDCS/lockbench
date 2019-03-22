#include "lock_wrapper.h"
#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <utils.h>
#include <sys/resource.h>
#include <errno.h>


#ifndef TEST_DURATION
#define TEST_DURATION 10
#endif

#define TRACE_LEN 1024*1024*100


typedef struct test_config {
	long spin_window_size;
	long threads;
	int randomized_ncs[2];
	int randomized_cs[2];
} test_config_t;


int parse_command_line(int argc, char** argv, test_config_t* config);


static volatile long cs_num;
static volatile long nolock;
static volatile unsigned long barrier = 0;
static unsigned int stop = 0;
static test_config_t config;
static int TEST_TIME=TEST_DURATION;

__thread long long cs_counter = 0;
__thread long long ncs_counter = 0;

unsigned long long TRACE_CNT=0;
unsigned long long TRACE_IDX=0;
char *trace = NULL;

void* stop_on_timeout_thread_routine(void* param) {

	size_t cs_exec_num = 0;
	struct drand48_data seed;
	unsigned int id = 0;



	// Increase the value of the barrier, when the parent execute this instruction
	// all childrens are allowed to start
	id = atomic_add(&barrier, 1);
    srand48_r(id+359, &seed);

	while(barrier != (config.threads+1));

	// Main loop
	while (!stop) {
		long ncs_op = config.randomized_ncs[0];
		long cs_op = config.randomized_cs[0];
		long random_num = 0;
		// Lock acquisition
		acquire_lock();
		lrand48_r(&seed, &random_num);
	
		if (config.randomized_cs[1] - config.randomized_cs[0]  > 0) {
			cs_op = ( random_num % (config.randomized_cs[1] - config.randomized_cs[0])) + config.randomized_cs[0];
		}

		// Critical section operations
		int j;
		for (j = 0; j < cs_op; ++j) {
			cs_counter += ((j % 2) ? (1) : (-1));
		}

		// Lock release
		release_lock();

		++cs_exec_num;
		lrand48_r(&seed, &random_num);
		
		if (config.randomized_ncs[1] - config.randomized_ncs[0] > 0) {
			ncs_op = ( random_num % (config.randomized_ncs[1] - config.randomized_ncs[0])) + config.randomized_ncs[0];
		}

		// Non-critical section operations
		for (j = 0; j < ncs_op; ++j) {
			ncs_counter += ((j % 2) ? (1) : (-1));
		}
	}

	atomic_add(&cs_num, cs_exec_num);

	return 0L;
}

void* trace_routine(void* param) {

	size_t cs_exec_num = 0;
	struct drand48_data seed;
	unsigned int id = 0;



	// Increase the value of the barrier, when the parent execute this instruction
	// all childrens are allowed to start
	id = atomic_add(&barrier, 1);
    srand48_r(id+359, &seed);

	while(barrier != (config.threads+1));

	// Main loop
	while (!stop) {
		long ncs_op = config.randomized_ncs[0];
		long cs_op = config.randomized_cs[0];
		long random_num = 0;
		// Lock acquisition
		acquire_lock();
		lrand48_r(&seed, &random_num);
	
		if (config.randomized_cs[1] - config.randomized_cs[0]  > 0) {
			cs_op = ( random_num % (config.randomized_cs[1] - config.randomized_cs[0])) + config.randomized_cs[0];
		}

		// Critical section operations
		int j;
		for (j = 0; j < cs_op; ++j) {
			cs_counter += ((j % 2) ? (1) : (-1));
		}
	#if defined(NSS_MUTLOCK_LOCK) || defined(THC1_MUTLOCK_LOCK) || defined(NSS2_MUTLOCK_LOCK) || defined(THC12_MUTLOCK_LOCK)\
			|| defined(SEM_NSS_MUTLOCK_LOCK) || defined(SEM_THC1_MUTLOCK_LOCK) || defined(SEM_NSS2_MUTLOCK_LOCK) || defined(SEM_THC12_MUTLOCK_LOCK) \
					|| defined(TCP_MUTLOCK_LOCK)  || defined(SEM_TCP_MUTLOCK_LOCK) || defined(SEM_TCP2_MUTLOCK_LOCK)
		if(trace != NULL && (TRACE_CNT == 0) ){
			trace[TRACE_IDX++] =  (unsigned char) ((lock.lstate) >> 32);
		}
		if(++TRACE_CNT == 100)
			TRACE_CNT = 0; 
	#elif defined(FREQ_MUTLOCK_LOCK) || defined(SEM_FREQ_MUTLOCK_LOCK)
                if(trace != NULL && (TRACE_CNT == 0) ){
                        trace[TRACE_IDX++] =  (unsigned char) ((lock.mtd.lstate) >> 32);
                }
                if(++TRACE_CNT == 100)
                        TRACE_CNT = 0;

	#endif
		// Lock release
		release_lock();

		++cs_exec_num;
		lrand48_r(&seed, &random_num);
		
		if (config.randomized_ncs[1] - config.randomized_ncs[0] > 0) {
			ncs_op = ( random_num % (config.randomized_ncs[1] - config.randomized_ncs[0])) + config.randomized_ncs[0];
		}

		// Non-critical section operations
		for (j = 0; j < ncs_op; ++j) {
			ncs_counter += ((j % 2) ? (1) : (-1));
		}
	}

	atomic_add(&cs_num, cs_exec_num);

	return 0L;
}

void* fake_routine(void* param) {
	printf("Running a test without locks\n");
	size_t cs_exec_num = 0;
	struct drand48_data seed;
	unsigned int id = 0;

	// Increase the value of the barrier, when the parent execute this instruction
	// all childrens are allowed to start
	id = atomic_add(&barrier, 1);
    srand48_r(id+359, &seed);

	while(barrier != (config.threads+1));

	// Main loop
	while (!stop) {
		long ncs_op = config.randomized_ncs[0];
		long cs_op = config.randomized_cs[0];
		long random_num = 0;
		// Lock acquisition
		acquire_lock();
		lrand48_r(&seed, &random_num);
	
		if (config.randomized_cs[1] - config.randomized_cs[0]  > 0) {
			cs_op = ( random_num % (config.randomized_cs[1] - config.randomized_cs[0])) + config.randomized_cs[0];
		}

		// Critical section operations
		int j;
		for (j = 0; j < cs_op; ++j) {
			cs_counter += ((j % 2) ? (1) : (-1));
		}

		// Lock release
		release_lock();

		++cs_exec_num;
		lrand48_r(&seed, &random_num);
		
		if (config.randomized_ncs[1] - config.randomized_ncs[0] > 0) {
			ncs_op = ( random_num % (config.randomized_ncs[1] - config.randomized_ncs[0])) + config.randomized_ncs[0];
		}

		// Non-critical section operations
		for (j = 0; j < ncs_op; ++j) {
			ncs_counter += ((j % 2) ? (1) : (-1));
		}
	}

	atomic_add(&cs_num, cs_exec_num);

	return 0L;
}




int main(int argc, char** argv) {
	if (-1 == parse_command_line(argc, argv, &config)) {
		printf ("Invalid command line.\n");
		return 1;
	}

	int j;
	struct timeval start, end;

	printf("Testing %s with %ld threads\n", lock_to_string(), config.threads);
	
	init_lock(config.spin_window_size);
	
	pthread_t* tids = (pthread_t*)malloc((config.threads) * sizeof(pthread_t));

	if(TRACE_CNT == 1){
		trace = (char*) malloc(sizeof(char)*TRACE_LEN);
	}	
	TRACE_CNT = 0;


	for (j = 0; j < config.threads; ++j) {
		if(!nolock && !trace)
			pthread_create(&tids[j], NULL, stop_on_timeout_thread_routine, NULL);
		else if(!nolock && trace)
			pthread_create(&tids[j], NULL, trace_routine, NULL);
		else if(nolock)
			pthread_create(&tids[j], NULL, fake_routine, NULL);		
	}

	atomic_add(&barrier, 1);
	while(barrier != (config.threads+1));

	gettimeofday(&start, NULL);

	sleep(TEST_TIME);

	atomic_add(&stop, 1);

	// Wait all threads to finish their execution
	for (j = 0; j < (config.threads); ++j) {
		pthread_join(tids[j], NULL);
	}
	gettimeofday(&end, NULL);

	float elapsed = ((end.tv_sec + end.tv_usec / 1000000.0) - (start.tv_sec + start.tv_usec / 1000000.0));
	
	printf(" ---- Throughput: %.5f CS/sec. CS time %.5f\n", cs_num / elapsed, elapsed*1000000/cs_num);			
	
	free(tids);

	destroy_lock();

	
	if(trace){
		for( j=0; j< TRACE_IDX; j++)
			printf("%d %d\n", j, trace[j]);
//			printf("%d\n", trace[j]);
	}
	

}



int parse_command_line(int argc, char** argv, test_config_t* config) {
	if (argc == 1) {
		printf("Invalid number of commands (%d).\n", argc);
		return -1;
	}

	else if (argc == 2 && (0 == strcmp(argv[1], "--help"))) {
		printf("Invalid command line.\n");
		return -1;
	}
	
	// Default values
	config->threads = 0;
	config->spin_window_size = 0;
	config->randomized_ncs[0] = 0;
	config->randomized_ncs[1] = 0;
	config->randomized_cs[0] = 0;
	config->randomized_cs[1] = 0;

	int idx = 1;
	for (; idx < argc; idx += 2) {
		
		// Parse threads configuration
		if (0 == strcmp(argv[idx], "-t")) {
			config->threads = atol(argv[idx + 1]);
		}

		// Parse spin window configuration
		else if (0 == strcmp(argv[idx], "-s")) {
			config->spin_window_size = atol(argv[idx + 1]);
		}
		
		// Parse lower bounds for randomized critical-section configuration
		else if (0 == strcmp(argv[idx], "-rnd_cs_lower")) {
			config->randomized_cs[0] = atol(argv[idx + 1]);
		}

		// Parse upper bound for randomized critical-section configuration
		else if (0 == strcmp(argv[idx], "-rnd_cs_higher")) {
			config->randomized_cs[1] = atol(argv[idx + 1]);
		}

		// Parse lower bounds for randomized non critical-section configuration
		else if (0 == strcmp(argv[idx], "-rnd_ncs_lower")) {
			config->randomized_ncs[0] = atol(argv[idx + 1]);
		}

		// Parse upper bound for randomized non critical-section configuration
		else if (0 == strcmp(argv[idx], "-rnd_ncs_higher")) {
			config->randomized_ncs[1] = atol(argv[idx + 1]);
		}
		else if (0 == strcmp(argv[idx], "-seq")) {
			nolock=1;
		}
		else if (0 == strcmp(argv[idx], "-l")) {
			TEST_TIME=atoi(argv[idx + 1]);
		}
		else if (0 == strcmp(argv[idx], "-trace")) {
			TRACE_CNT=1;
		}

		else {
			printf("Unrecognized parameter %s. Returning on error.\n", argv[idx]);
			return -1;
		}
	}

	return 0;
}
