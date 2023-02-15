
SRCS=$(wildcard src/*.s)
OBJS=$(SRCS:.s=.o)

%.o: %.s
	nasm -felf64 -i src $^

main: $(OBJS)
	ld -o $@ $^

.PHONY: all
all: main

.PHONY: clean
clean:
	rm -f src/*.o
	rm -f main
