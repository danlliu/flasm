
LIB_SRCS=$(filter-out src/main.s, $(wildcard src/*.s))
LIB_OBJS=$(LIB_SRCS:.s=.o)
TEST_SRCS=$(wildcard tst/test_*.s)
TEST_EXES=$(TEST_SRCS:tst/%.s=tst/%)

%.o: %.s
	nasm -felf64 -i src $^

main: src/main.o $(LIB_OBJS)
	ld -o $@ $^

tst/test_%: tst/test_%.o $(LIB_OBJS)
	ld -o $@ $^

.PHONY: all
all: main $(TEST_EXES)

.PHONY: clean
clean:
	rm -f src/*.o
	rm -f main
	rm -f $(TEST_EXES)
