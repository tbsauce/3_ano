CXX = g++
CXXFLAGS = -Wall

PROGS = atexit cmd-args-env fork1 fork2 fork3
PROGS += mem mem-fork launch

LDFLAGS = -pthread

.PHONY: all cleanall

all:	$(PROGS)

cleanall:
	rm -f $(PROGS)
