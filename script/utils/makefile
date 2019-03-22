
all: looper.o
	@gcc looper.o  -O0 -o looper
	@gcc looper2.o  -O0 -o looper2

looper.o: looper.c
	@gcc -c looper.c -O0 -o looper.o
	@gcc -c looper2.c -O0 -o looper2.o

clean:
	@rm looper.o looper looper2.o looper2
