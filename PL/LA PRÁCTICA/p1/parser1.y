%{
	
#include <iostream>
using namespace std;

int yylex(void);
int yyerror(const char *s);
%}

%union
{
	char * str;
	int num;
}

%token <num> CTI ZERO
%token <str> ID OP_PR CL_PR OP_SR CL_SR OP_BR CL_BR IF ELSE INT SEMICOLON EQUAL
%token <str> COMA AND OR NOT D_EQUAL MIN_EQUAL MAY_EQUAL NOT_EQUAL PLUS  MINUS  DIV MULT


%%

begin	:		begin expr		
		|
;
expr	:		asig		SEMICOLON 
;

asig    :		ID      EQUAL   arit_expr  

;
arit_expr	:	arit_expr 		PLUS  		factor
 			|	arit_expr 		MINUS  		factor
 			|	factor	
;

factor  :		factor     		MULT     	division
		|		factor     		DIV     	division
		|		division
;
division	:		MINUS   	division 
			|		CTI
			|		OP_PR	arit_expr	CL_PR
;


%%

int main() {
    cout<<"\n";
	yyparse();


    cout<<"he terminao crack"<<endl;
    cout<<"\n";
	return EXIT_SUCCESS;
} 

int yyerror(const char* msj) {
	cerr << msj << endl;
	return 1;
}
