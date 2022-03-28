all:	calc.exe

y.tab.c: calc.y
	yacc -d  calc.y

lex.yy.c: calc.l
	lex calc.l

calc.exe: y.tab.c lex.yy.c
	cc y.tab.c lex.yy.c  -o calc.exe

clean:
	rm calc.exe y.tab.c lex.yy.c

tests: 
	echo "x = " | ./calc.exe
	echo 
