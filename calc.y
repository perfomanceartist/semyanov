%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.h"
//extern int yylex();
void yyerror(char *msg);


%}

%union {
int num;
char letter;
}

%token <num> NUM_TOKEN LETTER_TOKEN VAR_TOKEN PRINT_TOKEN
%type <num> N M P 


%left '+' '-' 
%left '*'
%right '='
%%

S : COMMANDS;

COMMANDS : 
    COMMANDS PRINT_TOKEN VAR_TOKEN ';' 				{ if (!defined_vars[$3-'A']) yyerror("the variable is not defined"); printf("$%c:", $3); print_polynom($3-'A' + 100);}
  | COMMANDS VAR_TOKEN '=' P ';'	  { if (was_var[$4] && !defined_vars[was_var[$4]-'A']) yyerror("the variable is not defined"); was_var[$4] = 0; copy_polynom($2-'A' + 100, $4);	defined_vars[$2-'A'] = 1;}
  /*| COMMANDS P '=' P ';'    {
        //$2 не является переменной?
        if (!was_var[$2]) yyerror("you can assign value only to the variable");
        //$4 является объявленной переменной? 
        if (was_var[$4]) printf("$%c is variable\n", was_var[$4]);
        printf("%d\n", defined_vars[was_var[$4]-'A']);
        if (was_var[$4] && !defined_vars[was_var[$4]-'A']) yyerror("the variable is not defined");
        
        copy_polynom(was_var[$2]-'A' + 100, $4);	defined_vars[was_var[$2]-'A'] = 1;
        was_var[$2] = 0; was_var[$4] = 0;
  }*/
  |
  
  | COMMANDS P '=' P   PRINT_TOKEN      { line_number--; yyerror("Seems like you forgot the semicolon in the end of command"); }
  | COMMANDS P '=' P   VAR_TOKEN        { line_number--; yyerror("Seems like you forgot the semicolon in the end of command"); }
  | COMMANDS PRINT_TOKEN VAR_TOKEN PRINT_TOKEN  { line_number--; yyerror("Seems like you forgot the semicolon in the end of command"); }
  | COMMANDS PRINT_TOKEN VAR_TOKEN VAR_TOKEN    { line_number--; yyerror("Seems like you forgot the semicolon in the end of command"); }

  | COMMANDS P '='   ';'    { yyerror("Seems like you forgot polynom in assignment "); }
  | COMMANDS PRINT_TOKEN     ';'    { yyerror("Seems like you forgot polynom in printing"); }
  | COMMANDS P ';'                  { yyerror("Semantic error - there is no action"); }
  
  
  ;

P : P '*' P 			{ multiply_polynom($1, $3);	polynom_index = find_free_index(); $$ = $1;	}
  | P '+' P				{ add_polynom($1, $3); 	polynom_index = find_free_index(); $$ = $1;			}
  | P '-' P				{ negate_polynom($3); add_polynom($1, $3); 	polynom_index = find_free_index(); $$ = $1;				}
  | '(' P ')'			{ $$ = $2;																	      }
  | '(' ')'       { yyerror("Inacceptable usage of brackets: empty polynom");      }
  //| P  P           { yyerror("Two polynoms consecutively - maybe you forgot the sign");      }
  | M  					  { polynom_index = find_free_index(); add_nom(t_nom, polynom_index);  $$ = polynom_index; erase_t_nom();	}
  | VAR_TOKEN			{ polynom_index = find_free_index(); copy_polynom( polynom_index, $1-'A' + 100); $$ = polynom_index; 	was_var[polynom_index] = $1;	}
  ;



M : N T					{ t_nom.coef = $1; 			}
  | T 					{ t_nom.coef = 1; 			}
  | N					{ t_nom.coef = $1; 			}
  ;

T : T V 
  | V
  ;
N : NUM_TOKEN			{ $$ = $1;			} 
  | '+' NUM_TOKEN		{ $$ = $2;			} 
  | '-' NUM_TOKEN		{ $$ = -$2;			} 
  ;


V : LETTER_TOKEN		{ t_nom.vars[$1 - 'a'] = 1;		}
  | LETTER_TOKEN '^' N  { t_nom.vars[$1 - 'a'] = $3;	}
  ;



%%




void yyerror(char * msg) {
fprintf(stderr, "\nError in line #%d: %s\n", line_number, msg);

exit(1);
}

/*
int main() {
yyparse();

}
*/







