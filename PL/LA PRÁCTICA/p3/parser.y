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

%token <num> CTI 
%token <str> ID OP_PR CL_PR OP_SR CL_SR OP_BR CL_BR IF ELSE INT SEMICOLON EQUAL
%token <str> COMA AND OR NOT D_EQUAL MIN_EQUAL MAY_EQUAL NOT_EQUAL PLUS  MINUS  DIV MULT


%%

begin	:		begin	 expr		
		|
;
expr	:		decl		SEMICOLON 
		|		asig		SEMICOLON 
		|		c_if        
;
decl	:		b_type
		|		vector  
;
b_type	:		type    ID 
		|	    type    ID    EQUAL   CTI
;
type    :		INT
;
vector  :		type    ID    OP_SR	   CTI	  CL_SR
		|	  	type    ID    OP_SR	   CTI	  CL_SR   asig_v  
;
asig_v	:		EQUAL		OP_BR	CTI anotherCti CL_BR 
;
anotherCti	:	COMA	CTI     anotherCti
		|
;
asig    :		ID      asig_v
		|		ID      EQUAL   arit_expr  

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
c_if	:		IF      OP_PR     l_cond	  CL_PR		OP_BR	expr	CL_BR
		|		IF      OP_PR     l_cond	  CL_PR		OP_BR	expr	CL_BR
				ELSE	OP_BR	expr	CL_BR
;

l_cond	:		l_cond	logic	c_cond
		|		c_cond
;
c_cond	:		c_cond	comp	fact
		|		fact
;
fact	:		OP_PR    l_cond	 CL_PR		
		|		CTI
		|		ID				 
;
logic	:		AND
		|		OR
		|		NOT
;
comp	:		D_EQUAL
		|		MIN_EQUAL
		|		MAY_EQUAL
		|		NOT_EQUAL
;

%%

int main() {
    cout<<"\n";
	yyparse();



    cout<<"\n";
	return EXIT_SUCCESS;
} 

int yyerror(const char* msj) {
	cerr << msj << endl;
	return 1;
}
