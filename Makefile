cat > Makefile <<'EOF'
CC=gcc
AR=ar
CFLAGS=-Wall -g

all: main_static main_dynamic

# static library and program
libmylib.a: mylib.o
	$(AR) rcs $@ $^

mylib.o: mylib.c mylib.h
	$(CC) $(CFLAGS) -c mylib.c -o mylib.o

main_static: main_static.c libmylib.a
	$(CC) $(CFLAGS) main_static.c -L. -lmylib -o main_static

# shared library and program
libmylib.so: mylib_pic.o
	$(CC) -shared -o $@ $^

mylib_pic.o: mylib.c mylib.h
	$(CC) $(CFLAGS) -fPIC -c mylib.c -o mylib_pic.o

main_dynamic.o: main_dynamic.c mylib.h
	$(CC) $(CFLAGS) -c main_dynamic.c -o main_dynamic.o

main_dynamic: main_dynamic.o libmylib.so
	$(CC) $(CFLAGS) main_dynamic.o -L. -lmylib -o main_dynamic

run_dynamic: main_dynamic
	LD_LIBRARY_PATH=. ./main_dynamic

clean:
	rm -f *.o *.a *.so main_static main_dynamic
EOF
