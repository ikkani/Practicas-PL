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
%token <str> ID IF ELSE INT PRINTF
%token <str> AND OR NOT D_EQUAL MIN_EQUAL MAY_EQUAL NOT_EQUAL


%%

begin	:		begin	 expr		
		|
;
expr	:		decl		';' 
		|		asig		';' 
		|		print       ';'
		|		c_if        
;
decl	:		b_type
		|		vector  
;
b_type	:		type    ID 
		|	    type    ID    '='   CTI
;
type    :		INT
;
vector  :		type    ID    '['	   CTI	  ']'
		|	  	type    ID    '['	   CTI	  ']'   asig_v  
;
asig_v	:		'='		'{'	CTI anotherCti '}' 
;
anotherCti	:	','		CTI     anotherCti
		|
;
asig    :		ID      asig_v
		|		ID      '='   arit_expr  

;
arit_expr	:	arit_expr 		'+' 		factor
 			|	arit_expr 		'-'  		factor
 			|	factor	
;
factor  :		factor     		'*'     	division
		|		factor     		'/'     	division
		|		division
;
division	:		'-'   	division 
			|		CTI
			|		'('	    arit_expr	')'
;
print 	:		PRINTF		'('    '"'		'%' 	'd'     '"'   ','	ID   ')'
;
c_if	:		IF      '('     l_cond	  ')'		'{'		expr	'}'
		|		IF      '('     l_cond	  ')'		'{'		expr	'}'
				ELSE	'{'		expr	  '}'
;

l_cond	:		l_cond		logic		c_cond
		|		c_cond
;
c_cond	:		c_cond	comp	fact
		|		fact
;
fact	:		'('    l_cond	 ')'		
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
