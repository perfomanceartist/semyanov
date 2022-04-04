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

COMMANDS : COMMANDS PRINT_TOKEN VAR_TOKEN ';' 				{ printf("$%c:", $3); print_polynom($3-'A' + 100);}
  | COMMANDS VAR_TOKEN '=' P ';'	{ copy_polynom($2-'A' + 100, $4);	 }
  | COMMANDS VAR_TOKEN '=' VAR_TOKEN ';'	{ copy_polynom($2-'A' + 100, $4-'A' + 100);}
  | {printf("START\n");};
  ;

P : P '*' P 			{ multiply_polynom($1, $3);	polynom_index = find_free_index(); $$ = $1;	}
  | P '+' P				{ add_polynom($1, $3); 	polynom_index = find_free_index(); $$ = $1;			}
  | P '-' P				{ negate_polynom($3); add_polynom($1, $3); 	polynom_index = find_free_index(); $$ = $1;				}
  | '(' P ')'			{ $$ = $2;																	}
  | M  					{ polynom_index = find_free_index(); add_nom(t_nom, polynom_index);  $$ = polynom_index; erase_t_nom();	}
  | VAR_TOKEN			{ polynom_index = find_free_index(); copy_polynom( polynom_index, $1-'A' + 100); $$ = polynom_index; 		}
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
fprintf(stderr, "%s\n", msg);
exit(1);
}

/*
int main() {
yyparse();

}
*/







