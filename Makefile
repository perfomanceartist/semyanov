all:	calc.exe

y.tab.c: calc.y
	./bison/win_bison.exe -d  calc.y 

lex.yy.c: calc.l
	./bison/win_flex calc.l

calc.exe: y.tab.c lex.yy.c
	gcc  calc.tab.c lex.yy.c  -o calc.exe

clean:
	rm calc.exe y.tab.c lex.yy.c

tests: calc.exe
	./calc.exe ./tests/base.txt
	
	
	
	

