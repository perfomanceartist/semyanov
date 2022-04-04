%{

#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"


    extern int yylex();

	FILE *inputStream;

	#define yyin inputStream
	#define tmp_scanf(f_, ...) fscanf(yyin, (f_), __VA_ARGS__)

	int main(int argc, char* argv[])
	{
		inputStream = fopen(argv[1], "r");
		
		if (inputStream == NULL)
		{
			printf("File wasn't found\n");
			return -1;
		}

		yyparse();

		fclose(inputStream);
	}
%}

%option noyywrap


%%
[/][/].*      ;
[a-z] {yylval.letter = yytext[0]; return LETTER_TOKEN;}
"$"[A-Z] {yylval.letter = yytext[1]; return VAR_TOKEN;}
[0-9]+ {yylval.num = atoi(yytext); return NUM_TOKEN;}
[-+x()\*=\.] { return yytext[0];}
[ \t\f\v\n] {;}
"^" 		{return '^'; }
";"         {return ';'; }
">"         {return '>'; }
"PRINT"     {return PRINT_TOKEN;}
%%
