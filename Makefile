# Makefile

CC=gcc
SH = bash
CFLAGS = -g
LDFLAGS = -lm

a.out: lex.yy.c y.tab.o Graph.o Interpreter.o
	gcc -lm $^ -o $@

y.tab.o: y.tab.c y.tab.h
	gcc -c $(CFLAGS) $< -o $@

Graph.o: Graph.c Graph.h
	gcc -c $(CFLAGS) $< -o $@

Interpreter.o: Interpreter.c Interpreter.h
	gcc -c $(CFLAGS) $< -o $@

y.tab.c: a4.y
	yacc -t -v -d a4.y

lex.yy.c: a4.l
	lex a4.l

test: a.out
	bash eval.sh ./a.out testcases

clean:
	@rm lex.yy.c y.output y.tab.h y.tab.c *.out *.o

tar:
	@mv a.out /tmp/
	@mv testcases /tmp/
	@tar czf `ls -d1 ../CS* | grep -v tar | grep -v 000`.tar.gz `ls -d1 ../CS* | grep -v tar | grep -v 000`
	@mv /tmp/testcases .
	@mv /tmp/a.out .
	@ls -d1 ../CS*.tar.gz | grep -v 000
