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

int add_nom(int coef, int deg, int index);
void print_polynom(int index);
void negate_polynom(int index1);
void add_list_append(int index1, int index2);
void add_polynom(int index1, int index2);
void make_sum();
void multiply_polynom(int index1, int index2);

typedef struct {
	int i1;
	int i2;
} add_list_node;

add_list_node add_list[100];
int add_list_num = 0;



%}

%union {
int num;
}

%token <num> NUM_TOKEN
%type <num> N M E P T
//%type <letter> L

%left '+' '-' '*'
 

%%

S : T					{ make_sum(); printf("Result:"); print_polynom(0);						}
  ;
T : T '*' P 			{ /*printf("Multipying %d and %d\n", $1, $3); */multiply_polynom($1, $3);	$$ = $1; /*print_polynom($1);		*/			}
  | T '+' P 			{ add_list_append($1, $3); 		$$ = $3;					}
  | T '-' P 			{ negate_polynom($3); add_list_append($1, $3);  	$$ = $3;	}
  | P					{ $$ = $1;		/*printf("T:P, P = %d\n", $$);	*/									}
  ;

P : '(' E ')'			{ /*printf("New polynom with index %d:", $2); print_polynom($2);*/	polynom_index++;	$$ = $2;		}
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


%%


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

void print_polynom(int index) {
	//printf("RESULT:\n");
	if (nom_number[index] == 0) printf("0");
	for (int i = 0; i < nom_number[index]; i++) {
		//printf("COEF: %d; Letter: %c; Degree: %d\n", polynom[i].coef, polynom[i].letter, polynom[i].deg);
		if (polynom[index][i].coef > 0) printf("+");		
		if (polynom[index][i].coef !=1 || polynom[index][i].deg == 0) {
			
			printf("%d", polynom[index][i].coef);
		}
		if (polynom[index][i].deg != 0)  {
			printf("x");
			if (polynom[index][i].deg != 1) printf("^%d", polynom[index][i].deg);
		}
		printf(" ");

		/*if (polynom[index][i].coef > 0) printf("+%d*%c^%d ", polynom[index][i].coef, 'x', polynom[index][i].deg);
		else printf("%d*%c^%d ", polynom[index][i].coef, 'x', polynom[index][i].deg); */
	}
	printf("\n");
}

void negate_polynom(int index1) {
	for (int i = 0; i < nom_number[index1]; i++) {
		polynom[index1][i].coef *= -1;
	}
}

void add_list_append(int index1, int index2) {
	add_list[add_list_num].i1 = index1;
	add_list[add_list_num].i2 = index2;
	add_list_num++;
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

void make_sum() {
	for (int i = add_list_num - 1; i >= 0; i--) {
		add_polynom(add_list[i].i1, add_list[i].i2);
	}
	add_list_num = 0;

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

void yyerror(char * msg) {
fprintf(stderr, "%s\n", msg);
exit(1);
}



int main() {
yyparse();

}








