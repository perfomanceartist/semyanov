all:	calc.exe

y.tab.c: calc.y
	./bison/win_bison.exe -d  calc.y 

lex.yy.c: calc.l
	./bison/win_flex calc.l

calc.exe: y.tab.c lex.yy.c
	gcc  calc.tab.c lex.yy.c  -o calc.exe

clean:
	rm calc.exe y.tab.c lex.yy.c

tests:
	echo "1;" | calc.exe
	echo "2x+1;" | calc.exe
	echo "2x-1;" | calc.exe
	echo "-1+2x;" | calc.exe
	echo "-1-2x;" | calc.exe
	echo "7x^2;" | calc.exe
	echo "x^-3;" | calc.exe
	echo "+1 +3x;" | calc.exe
	
	echo "1 * 2x;" | calc.exe
	echo "7x*7x;" | calc.exe
	echo "x*x^-1;" | calc.exe
	echo "x*x*x*x;" | calc.exe
	echo "(x)*(x)*(x);" | calc.exe
	echo "1 + x*x;" | calc.exe

	echo "(1) + (2x)*(3) + (x^2) ; " | calc.exe
	echo "(2x)*(3) + (x^2) + (1) ; " | calc.exe
	echo "(2x)*(3) + (x^2 + 1) ; " | calc.exe
	echo "(x^2 + 1) + (2x)*(3) ; " | calc.exe
	
	
	
	

