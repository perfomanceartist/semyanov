%{

#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"
%}

%option noyywrap


%%
[a-z] {yylval.letter = yytext[0]; return LETTER_TOKEN;}
[0-9]+ {yylval.num = atoi(yytext); return NUM_TOKEN;}
[-+x()\*=\.] { return yytext[0];}
[ \t\f\v\n] {;}
"^" 		{return '^'; }
";"         {return ';'; }


%%
