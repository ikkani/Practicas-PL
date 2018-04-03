%{
	
#include <iostream>
using namespace std;

int yylex(void);
int yyerror(const char *s);
%}



%union
{
	char * str;
}


%token<str> ID EQUAL TRUE FALSE AND OR NOT PRINT

%%

begin	: 	begin 		expr 		';'   	
		|		

expr	:		ID EQUAL ar_expr   
        |       PRINT ar_expr
	
ar_expr :		ar_expr		OR			conc
		|		conc

conc	:		conc		AND		    disy
		|		disy

disy	:		NOT			disy
		|		ID
		|		TRUE        
		|		FALSE
		|		'('			ar_expr		 	')'

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
