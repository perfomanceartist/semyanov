%{

#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%option noyywrap


%%

[0-9]+ {yylval.num = atoi(yytext); return NUM_TOKEN;}
[-+x()\*=\.] { return yytext[0];}
[ \t\f\v\n] {;}




%%
