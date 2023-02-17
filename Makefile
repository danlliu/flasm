
LIB_SRCS=$(wildcard src/*.s)
LIB_OBJS=$(LIB_SRCS:.s=.o)
TEST_SRCS=$(wildcard tst/test_*.s)
TEST_EXES=$(TEST_SRCS:tst/%.s=%)

%.o: %.s
	nasm -felf64 -i src $^

main: $(LIB_OBJS)
	ld -o $@ $^

test_%: tst/test_%.o
	ld -o $@ $^

.PHONY: all
all: main $(TEST_EXES)

.PHONY: clean
clean:
	rm -f src/*.o
	rm -f main
