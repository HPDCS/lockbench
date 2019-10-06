#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#define READ_OP     0
#define WRITE_OP    1
#define READ_PR     0.5
#define WRITE_PR    0.5

#define READ_NUM   10
#define WRITE_NUM  10
#define BUFFER_SIZE 1000000

int main() {
	char * buffer = (char*)calloc(BUFFER_SIZE, sizeof(char));
	
	srand(time(NULL));
	while (1) {
		double rnd = rand() / (double)RAND_MAX;
		if (rnd <= READ_PR) {
			long long cnt = 0;
			int reads = READ_NUM;
			while (reads--) {
				cnt += buffer[rand() % BUFFER_SIZE];
			}
		}
		
		else {
			int writes = WRITE_NUM;
			while (writes--) {
				buffer[rand() % BUFFER_SIZE] = rand() % 100;
			}
		}
	}
}
