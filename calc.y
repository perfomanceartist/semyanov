%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(char *msg);

typedef struct {
int deg;
int coef;
} nom;

nom polynom[3][100];
int nom_number[3] = {0, 0, 0};
//nom_number[0] = 0; nom_number[1] = 0; nom_number[2] = 0;
int polynom_index = 0;

int add_nom(int coef, int deg, int index) {
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


void multiply_polynom() {
	if (polynom_index == 0) {
	polynom_index++;
	return ;
	
	}

	for (int i = 0; i < nom_number[0]; i++) {
		for(int j =0; j < nom_number[1]; j++) {
			add_nom(polynom[0][i].coef*polynom[1][j].coef, polynom[0][i].deg + polynom[1][j].deg, 2);
		}	
	}
	
	for (int i = 0; i < nom_number[0]; i++)  {
		polynom[0][i].coef = 0;;
		polynom[0][i].deg = 0;
	}
	for (int i = 0; i < nom_number[1]; i++)  {
		polynom[1][i].coef = 0;;
		polynom[1][i].deg = 0;
	}
	


	for (int i = 0; i < nom_number[2]; i++)  {
		polynom[0][i].coef = polynom[2][i].coef;
		polynom[0][i].deg = polynom[2][i].deg;
	}
	for (int i = 0; i < nom_number[2]; i++)  {
		polynom[2][i].coef = 0;;
		polynom[2][i].deg = 0;
	}
	
	
	
	nom_number[0] = nom_number[2];
	nom_number[1] = 0;
	nom_number[2] = 0;

	
}

%}

%union {
int num;
}

%token <num> NUM_TOKEN
//%token <letter> LETTER_TOKEN
//%token <deg> DEGREE_TOKEN 
/*%type <f> E T F */
%type <num> N M
//%type <letter> L


%%
S : E '='		 {  multiply_polynom(); polynom_index = 0; print_polynom(); exit(1); }  
  ;



E : E '*'		{  multiply_polynom(); }
  | E '+' M 
  | M                       
  ;



M : N 'x' '.' N 	{ /*printf("COEF: %d; Degree: %d\n", $1,  $4); */$$ = add_nom($1,  $4, polynom_index);}
  | N 'x' '.' '+' N 	{ /*printf("COEF: %d; Degree: %d\n", $1,  $5); */$$ = add_nom($1,  $5, polynom_index);}
  | N 'x' '.' '-' N 	{ /*printf("COEF: %d; Degree: %d\n", $1,  -$5); */$$ = add_nom($1, - $5, polynom_index);}

  | N 'x'		{ /*printf("COEF: %d; Degree: %d\n", $1,  1); */$$ = add_nom($1, 1, polynom_index);}
  | 'x' '.' N		{ /*printf("COEF: %d; Degree: %d\n", 1, $3);*/ $$ = add_nom(1,  $3, polynom_index);}
  | 'x' '.' '+' N	{ /*printf("COEF: %d; Degree: %d\n", 1, $4);*/ $$ = add_nom(1,  $4, polynom_index);}
  | 'x' '.' '-' N	{ /*printf("COEF: %d; Degree: %d\n", 1, -$4);*/ $$ = add_nom(1,  -$4, polynom_index);}
  | 'x'			{ /*printf("COEF: %d; Degree: %d\n", 1,  1);*/ $$ = add_nom(1, 1, polynom_index); }
  | N 			{ /*printf("COEF: %d; Degree: 0\n", $1); */$$ = add_nom($1, 0, polynom_index); }
  ;



N : NUM_TOKEN 	  	{$$ = $1;} 
  ;

 


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








