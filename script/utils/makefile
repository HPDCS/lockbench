
all: looper.o core-jammer.o
	@gcc looper.o  -O0 -o looper
	@gcc looper2.o  -O0 -o looper2
	@gcc core-jammer.o  -O0 -o core-jammer

looper.o: looper.c
	@gcc -c looper.c -O0 -o looper.o
	@gcc -c looper2.c -O0 -o looper2.o
	
core-jammer.o: core-jammer.c
	@gcc -c core-jammer.c -O0 -o core-jammer.o

clean:
	@rm -f looper.o looper looper2.o looper2 core-jammer.o core-jammer
