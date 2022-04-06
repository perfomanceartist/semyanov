%{

#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"

	extern unsigned line_number;
    extern int yylex();
	extern void yyerror(char * msg);
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
[/][/].*    {  ;												}
[/]			{ yyerror("One slash error - maybe you forgot second for comment?");	 }
[a-z] 		{ yylval.letter = yytext[0]; return LETTER_TOKEN;	}
[A-Z]		{ yyerror("Big letters as polynom elements are inacceptable, use small letters");						}
"$"[A-Z] 	{ yylval.letter = yytext[1]; return VAR_TOKEN;		}
"$"[a-z] 	{ yyerror("Small letters as variables are inacceptable, use big letters");		}
("$")"$"+	{ yyerror("More than one dollar signs is inacceptable");		}	
[0-9]+ 		{ yylval.num = atoi(yytext); return NUM_TOKEN;		}
[-+()\*=\.] { return yytext[0];		}
[ \t\f\v] 	{ ; 					}
"\n"		{ line_number++;		}
"^" 		{ return '^'; 			}
";"         { return ';'; 			}
"PRINT"     { return PRINT_TOKEN;	}
. 			{ yyerror("Unrecognised symbol");	 }
%%
