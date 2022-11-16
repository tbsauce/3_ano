CXXFLAGS = -Wall -ggdb -pthread -D__DEBUG__
CXXFLAGS = -Wall -ggdb -pthread #-D__DEBUG__

LDFLAGS = -pthread -lm

TARGETS = main

all:	$(TARGETS)

main:	main.o sos.o utils.o process.o
		g++ -o $@ $^ $(LDFLAGS)

sos.o:	sos.h dbc.h utils.h

utils.o process.o:	utils.h dbc.h process.h

main.o:	sos.h dbc.h utils.h 

clean:
		rm -f *.o *~

cleanall:	clean
		rm -f $(TARGETS)
