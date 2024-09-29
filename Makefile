server: server.s constants.s
	as server.s -o $@.o
	gcc $@.o -o $@ -nostdlib -static

all: server
clean:
	rm server.o server
