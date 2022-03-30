%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(char *msg);

typedef struct {
int deg;
int coef;
} nom;
nom t_nom;




nom polynom[100][100];
int nom_number[100] = {0, 0, 0};
//nom_number[0] = 0; nom_number[1] = 0; nom_number[2] = 0;
int polynom_index = 0;

int add_nom(int coef, int deg, int index) {
       // printf("Adding %d * x ^ %d in %d polynom\n", coef, deg, index);
	for (int i = 0; i < nom_number[index]; i++ ) 
		if (polynom[index][i].deg == deg) {
			if (polynom[index][i].coef + coef == 0) {
				polynom[index][i].coef = polynom[index][nom_number[index]].coef;
				polynom[index][i].deg = polynom[index][nom_number[index]].deg;
				nom_number[index]--;
				return -1;
			}
			polynom[index][i].coef += coef;
			return i;
		}
	

	polynom[index][nom_number[index]].coef = coef;
	polynom[index][nom_number[index]].deg = deg;
	nom_number[index]++;
	return nom_number[index];
}

void print_polynom() {
	polynom_index = 0;
	printf("RESULT:\n");
	if (nom_number[polynom_index] == 0) printf("0");
	for (int i = 0; i < nom_number[polynom_index]; i++) {
		//printf("COEF: %d; Letter: %c; Degree: %d\n", polynom[i].coef, polynom[i].letter, polynom[i].deg);
		if (polynom[polynom_index][i].coef > 0) printf("+");		
		if (polynom[polynom_index][i].coef !=1 || polynom[polynom_index][i].deg == 0) {
			
			printf("%d", polynom[polynom_index][i].coef);
		}
		if (polynom[polynom_index][i].deg != 0)  {
			printf("x");
			if (polynom[polynom_index][i].deg != 1) printf("^%d", polynom[polynom_index][i].deg);
		}
		printf(" ");

		/*if (polynom[polynom_index][i].coef > 0) printf("+%d*%c^%d ", polynom[polynom_index][i].coef, 'x', polynom[polynom_index][i].deg);
		else printf("%d*%c^%d ", polynom[polynom_index][i].coef, 'x', polynom[polynom_index][i].deg); */
	}
	printf("\n");
}

void negate_polynom(int index1) {
	for (int i = 0; i < nom_number[index1]; i++) {
		polynom[index1][i].coef *= -1;
	}
}

void add_polynom(int index1, int index2) {
	for (int i = 0; i < nom_number[index2]; i++) {
		add_nom(polynom[index2][i].coef, polynom[index2][i].deg, index1);
	}
	
	for (int i = 0; i < nom_number[index2]; i++)  {
		polynom[index2][i].coef = 0;;
		polynom[index2][i].deg = 0;
	}

	nom_number[index2] = 0;
}

void multiply_polynom(int index1, int index2) {
	/*if (polynom_index == 0) {
	polynom_index++;
	return ;	
	} */

	for (int i = 0; i < nom_number[index1]; i++) {
		for(int j =0; j < nom_number[index2]; j++) {
			add_nom(polynom[index1][i].coef*polynom[index2][j].coef, polynom[index1][i].deg + polynom[index2][j].deg, 99);
		}	
	}
	
	for (int i = 0; i < nom_number[index1]; i++)  {
		polynom[index1][i].coef = 0;;
		polynom[index1][i].deg = 0;
	}
	for (int i = 0; i < nom_number[index2]; i++)  {
		polynom[index2][i].coef = 0;;
		polynom[index2][i].deg = 0;
	}
	


	for (int i = 0; i < nom_number[99]; i++)  {
		polynom[index1][i].coef = polynom[99][i].coef;
		polynom[index1][i].deg = polynom[99][i].deg;
	}
	for (int i = 0; i < nom_number[99]; i++)  {
		polynom[99][i].coef = 0;;
		polynom[99][i].deg = 0;
	}
	
	
	
	nom_number[index1] = nom_number[99];
	nom_number[index2] = 0;
	nom_number[99] = 0;

	
}

%}

%union {
int num;
}

%token <num> NUM_TOKEN
%type <num> N M E P T
//%type <letter> L

%left '+' '-' '*'
 

%%

S : T					{ print_polynom();						}
  ;
T : T '*' P 			{ multiply_polynom($1, $3);	$$ = $1;					}
  | T '+' P 			{ add_polynom($1, $3); 		$$ = $1;					}
  | T '-' P 			{ negate_polynom($3); add_polynom($1, $3); 	$$ = $1;	}
  | P					{ $$ = $1;												}
  ;

P : '(' E ')'			{ polynom_index++;	$$ = $2;		}
  |  E 					{ polynom_index++;	$$ = $1;		}
  ;

E : E '+' M				{ add_nom(t_nom.coef, t_nom.deg, polynom_index); $$ = $1;				}
  | E '-' M 			{ add_nom(-t_nom.coef, t_nom.deg, polynom_index); $$ = $1;				}
  | M					{ add_nom(t_nom.coef, t_nom.deg, polynom_index); $$ = polynom_index;	}
  ;

M : N 'x' 				{ t_nom.coef = $1; t_nom.deg = 1;	}
  | N 'x' '^' N 		{ t_nom.coef = $1; t_nom.deg = $4;	}
  | N					{ t_nom.coef = $1; t_nom.deg = 0;	}
  | 'x'					{ t_nom.coef = 10; t_nom.deg = 1;	}
  | N 'x'				{ t_nom.coef = $1; t_nom.deg = 1;	}
  | 'x' '^' N			{ t_nom.coef = 1; t_nom.deg = $3;	}
  ;

N : NUM_TOKEN			{ $$ = $1;			} 
  | '+' NUM_TOKEN		{ $$ = $2;			} 
  | '-' NUM_TOKEN		{ $$ = -$2;			} 
  ;

/*
S : E '='		 {  multiply_polynom(); polynom_index = 0; print_polynom(); exit(0); }  
  ;



E : E '*' M		{  multiply_polynom(); add_nom(t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0; }
  | E '*' '+' M		{  multiply_polynom(); add_nom(t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0; }
  | E '*' '-' M		{  multiply_polynom(); add_nom(-t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0; }
  | E '+' M 		{  add_nom(t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0;}  
  | E '-' M 		{  add_nom(-t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0;}  
  | M                   {  add_nom(t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0;}    
  | '+' M       	{  add_nom(t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0;}
  | '-' M               {  add_nom(-t_nom.coef, t_nom.deg, polynom_index); t_nom.coef = 0; t_nom.deg = 0;}    
    
  ;



M : N 'x' '^' N 	{ t_nom.coef = $1; t_nom.deg = $4;	}
  | N 'x' '^' '+' N 	{ t_nom.coef = $1; t_nom.deg = $5;	}
  | N 'x' '^' '-' N 	{ t_nom.coef = $1; t_nom.deg = -$5;	}

  | N 'x'		{ t_nom.coef = $1; t_nom.deg = 1;	}
  | 'x' '^' N		{ t_nom.coef = 1; t_nom.deg = $3;	}
  | 'x' '^' '+' N	{ t_nom.coef = 1; t_nom.deg = $4;	}
  | 'x' '^' '-' N	{ t_nom.coef = 1; t_nom.deg = -$4;	}
  | 'x'			{ t_nom.coef = 1; t_nom.deg = 1;	}
  | N 			{ t_nom.coef = $1; t_nom.deg = 0;	}
  ;



N : NUM_TOKEN 	  	{$$ = $1;} 
  ;

*/
 


/*S : E {printf("%f\n", $1); }
  ;

E : E '+' T {$$ = $1 + $3;}
  | E '-' T {$$ = $1 - $3;}
  | T 	    {$$=$1;}
  ;

T : T '*' F {$$ = $1 * $3;}
  | T '/' F {$$ = $1 / $3;}
  | F      {$$=$1;}
  ;

F : '(' E ')' {$$ = $2;}
  | '-' F     {$$ = - $2;}
  | '+' F     {$$=$2;}
  | NUM       {$$ = $1;}
  ;
*/

%%



void yyerror(char * msg) {
fprintf(stderr, "%s\n", msg);
exit(1);
}



int main() {
yyparse();

}








