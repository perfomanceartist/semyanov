typedef struct {
int vars[26]; //степени
int coef;
} nom;
nom t_nom;




nom polynom[200][100];
int nom_number[200] = {0};
int polynom_index = 0;

int add_nom(nom insert_nom, int index);
void print_polynom(int index);
void negate_polynom(int index1);
void add_list_append(int index1, int index2);
void add_polynom(int index1, int index2);
void make_sum();
void multiply_polynom(int index1, int index2);
int find_free_index();
void erase_t_nom();
void copy_polynom(int index1, int index2);
void erase_polynom(int index);
typedef struct {
	int i1;
	int i2;
} add_list_node;

add_list_node add_list[100];
int add_list_num = 0;

unsigned line_number = 1;

char defined_vars[26] = {0};
char was_var[99] =  {0};

void erase_t_nom() {
    t_nom.coef = 0;
    for (int s =0; s <26;s++) t_nom.vars[s] = 0;
}

int find_free_index() {
	for (int i=0; i < 100; i++) {
		if (nom_number[i] == 0) return i;
	}
	return -1;
}

int add_nom(nom insert_nom, int index) { //Добавить моном в полином 
       // printf("Adding %d * x ^ %d in %d polynom\n", coef, deg, index);
    //print_polynom(index);
	for (int i = 0; i < nom_number[index]; i++ ) {
		char looks_alike = 1;
		for (int j = 0; j < 26; j++) {
			if (insert_nom.vars[j] != polynom[index][i].vars[j]) {
				looks_alike = 0; break;
			}
		}
		if (!looks_alike) continue;

		//нашли такой же моном в полиноме, надо добавить коэффициент
		polynom[index][i].coef += insert_nom.coef;
		if (polynom[index][i].coef == 0) {
            nom_number[index]--;
			polynom[index][i].coef = polynom[index][nom_number[index]].coef;
			for (int j = 0; j < 26; j++) polynom[index][i].vars[j] = polynom[index][nom_number[index]].vars[j];
            
			return -1;
		}
		return i;
	}

	polynom[index][nom_number[index]].coef = insert_nom.coef;
	for (int j = 0; j < 26; j++) polynom[index][nom_number[index]].vars[j] = insert_nom.vars[j];
	nom_number[index]++;
	return nom_number[index];
}

void print_polynom(int index) {
	//printf("RESULT:\n");
    //printf("nom_number[index] = %d\n", nom_number[index]);
	if (nom_number[index] == 0) printf("0");
	for (int i = 0; i < nom_number[index]; i++) {
		//printf("COEF: %d; Letter: %c; Degree: %d\n", polynom[i].coef, polynom[i].letter, polynom[i].deg);
		if (polynom[index][i].coef > 0) printf("+");	
        char contains_vars = 0;
        for (int j =0; j < 26; j++) if (polynom[index][i].vars[j] !=0) contains_vars = 1;
		if (polynom[index][i].coef !=1 || !contains_vars) {
			
			printf("%d", polynom[index][i].coef);
		}
        for (int j =0; j < 26; j++) {
            if (polynom[index][i].vars[j] != 0) {
                printf("%c", j + 'a');
                if (polynom[index][i].vars[j] != 1) printf("^%d", polynom[index][i].vars[j]);
            }
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
    //print_polynom(index1);
}

void add_list_append(int index1, int index2) {
	add_list[add_list_num].i1 = index1;
	add_list[add_list_num].i2 = index2;
	add_list_num++;
}
void add_polynom(int index1, int index2) {
	nom nom_temp;
    //printf("%d:", index2); print_polynom(index2);
	for (int i = 0; i < nom_number[index2]; i++) {
		nom_temp.coef = polynom[index2][i].coef;
		for (int j = 0; j < 26; j++) nom_temp.vars[j] = polynom[index2][i].vars[j];
		add_nom(nom_temp, index1);
	}
	//printf("%d:", index1); print_polynom(index1);
	erase_polynom(index2);
}

void make_sum() {
	for (int i = add_list_num - 1; i >= 0; i--) {
		add_polynom(add_list[i].i1, add_list[i].i2);
	}
	add_list_num = 0;

}



void multiply_polynom(int index1, int index2) {
    nom temp_nom;
	for (int i = 0; i < nom_number[index1]; i++) {
		for(int j =0; j < nom_number[index2]; j++) {
            temp_nom.coef = polynom[index1][i].coef*polynom[index2][j].coef;
            for (int s = 0; s < 26; s++) temp_nom.vars[s] = polynom[index1][i].vars[s]+polynom[index2][j].vars[s];
			add_nom(temp_nom, 99);            
		}	
	}

    erase_polynom(index1);
    erase_polynom(index2);
    copy_polynom(index1, 99);
    erase_polynom(99);

	/*
	for (int i = 0; i < nom_number[index1]; i++)  {
		polynom[index1][i].coef = 0;;
		for (int s = 0; s < 26; s++) polynom[index1][i].vars[s] = 0;
	}
	for (int i = 0; i < nom_number[index2]; i++)  {
		polynom[index2][i].coef = 0;;
		for (int s = 0; s < 26; s++) polynom[index2][i].vars[s] = 0;
	}
	


	for (int i = 0; i < nom_number[99]; i++)  {
		polynom[index1][i].coef = polynom[99][i].coef;
		for (int s = 0; s < 26; s++) polynom[index1][i].vars[s] = polynom[99][i].vars[s];
	}
	for (int i = 0; i < nom_number[99]; i++)  {
		polynom[99][i].coef = 0;;
		for (int s = 0; s < 26; s++) polynom[99][i].vars[s] = 0;
	}
	
	
	
	nom_number[index1] = nom_number[99];
	nom_number[index2] = 0;
	nom_number[99] = 0;
    */
	
}

void copy_polynom(int index1, int index2) {
    erase_polynom(index1);
    for (int i = 0; i < nom_number[index2]; i++) {
        polynom[index1][i].coef = polynom[index2][i].coef;
        for (int j = 0;j<26; j++) polynom[index1][i].vars[j] = polynom[index2][i].vars[j];
    }
    nom_number[index1] = nom_number[index2];
}


void erase_polynom(int index) {
    for (int i = 0; i < nom_number[index]; i++) {
        polynom[index][i].coef = 0;
        for (int j = 0;j<26; j++) polynom[index][i].vars[j] = 0;
    }
    nom_number[index] = 0;
}