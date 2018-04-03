%{
#include <iostream>
#include <string>
#include <algorithm>

#include "parser.tab.h"
using namespace std;

int line_num = 1;
%}

ID 					[a-zA-Z_][a-zA-Z0-9_A-Z]*
CTI                 [0-9]+		
OP_PR               [(]
CL_PR               [)]
OP_SR               [[]
CL_SR               []]
OP_BR               [{]
CL_BR               [}]
IF					"if"
ELSE			    "else"
INT 				"int"[ \t\n]+
SEMICOLON			";"
EQUAL				"="
AND					[ \n\t]*"AND"
OR					[ \n\t]*"OR"
NOT					[ \n\t]*"NOT"
D_EQUAL			    "=="
MIN_EQUAL			"<="
MAY_EQUAL			">="
NOT_EQUAL			"!="
COMA 				","
PLUS			    "+"
MINUS				"-"
MULT				"*"
DIV				    "/"

%option noyywrap

%x comment

%%
[ \n\t]             ;
{IF}				return IF;
{ELSE}				return ELSE;
{ID}      			return ID;
{CTI}  			    {yylval.num = atoi(yytext); return CTI;}
{OP_PR}   			return OP_PR;
{CL_PR}   			return CL_PR;
{OP_SR}   			return OP_SR;
{CL_SR}   			return CL_SR;
{OP_BR}   			return OP_BR;
{CL_BR}   			return CL_BR;
{INT}				return INT;
{SEMICOLON}			return SEMICOLON;
{EQUAL}				return EQUAL;
{AND}				return AND;
{OR}				return OR;
{NOT}               return NOT;
{D_EQUAL}			return D_EQUAL;
{MIN_EQUAL}			return MIN_EQUAL;
{MAY_EQUAL}			return MAY_EQUAL;
{NOT_EQUAL}			return NOT_EQUAL;
{COMA}				return COMA;
{PLUS}				return PLUS;
{MINUS}				return MINUS;
{MULT}				return MULT;
{DIV}				return DIV;

"/*"         BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);

"//"[^\n]*

.
%%
/*
int main() {
    cout<<"\n";
    yylex();
    cout<<"\n";
} */