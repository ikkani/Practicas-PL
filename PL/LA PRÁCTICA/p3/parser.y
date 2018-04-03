%{
	
#include <iostream>
#include <map>
#include <cstring>
using namespace std;

map <char *,int> table;
int yylex(void);
int yyerror(const char *s);
%}

%union
{
	char * str;
	int num;
}

%token <num> CTI 
%token <str> ID IF ELSE INT PRINTF PORD
%token <str> AND OR NOT D_EQUAL MIN_EQUAL MAY_EQUAL NOT_EQUAL
%type  <num> factor
%type  <num> division
%type  <num> arit_expr



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
vector  :		type    ID    '['	   CTI	     ']'
		|	  	type    ID    '['	   CTI	     ']'      asig_v  
;
asig_v	:		'='		'{'	CTI anotherCti '}' 
;
anotherCti	:	','		CTI     anotherCti
		|
;
asig    :		ID      asig_v
		|		ID      '='   arit_expr  { table[*$1] = $3;}

;
arit_expr	:	arit_expr 		'+' 		factor
 			|	arit_expr 		'-'  		factor
 			|	factor	{$$ = $1;}
;
factor  :		factor     		'*'     	division
		|		factor     		'/'     	division
		|		division   {$$ = $1;}
;
division	:		'-'   	division  {$$ = -$2;}
			|		CTI     {$$ = $1;}
			|		'('	    arit_expr 	 ')' {$$ = $2;}
;
print 	:		PRINTF		'('    '"'   PORD   '"'     ','	   ID   ')'
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

	for (map<char *,int>::iterator i = table.begin(); i != table.end() ; i++){
	    cout << "\nLa variable " << i -> first << " tiene el valor " << i ->second ; 
	}

    cout<<"\n";
	return EXIT_SUCCESS;
} 

int yyerror(const char* msj) {
	cerr << msj << endl;
	return 1;
}
