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
	echo "x + 1= " | ./calc.exe
	echo "1x - 1= " | ./calc.exe
	echo "-3x + 1= " | ./calc.exe
	echo "x^2 + x= " | ./calc.exe
	echo "5x^2 - x^-3 =  " | ./calc.exe
	echo "5x^2 - 5x^2 =  " | ./calc.exe
	
	echo "x + 1 * x = " | ./calc.exe
	echo "x + 1 * x + 1 = " | ./calc.exe
	echo "x + 1 * -x^2 = " | ./calc.exe
	echo "x + 1 * -x^3 + x = " | ./calc.exe
	echo "2x^2 -3x + 7 -3x^-1 * x * x * x  = " | ./calc.exe

