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
IF					"if"
ELSE			    "else"
INT 				"int"[ \t\n]+
AND					[ \n\t]*"AND"
OR					[ \n\t]*"OR"
NOT					[ \n\t]*"NOT"
D_EQUAL			    "=="
MIN_EQUAL			"<="
MAY_EQUAL			">="
NOT_EQUAL			"!="
PRINTF				"printf"

%option noyywrap

%x comment

%%
[ \n\t]             ;
{IF}				return IF;
{ELSE}				return ELSE;
{PRINTF}            return PRINTF;
{ID}      			return ID;
{CTI}  			    {yylval.num = atoi(yytext); return CTI;}
{INT}				return INT;
{AND}				return AND;
{OR}				return OR;
{NOT}               return NOT;
{D_EQUAL}			return D_EQUAL;
{MIN_EQUAL}			return MIN_EQUAL;
{MAY_EQUAL}			return MAY_EQUAL;
{NOT_EQUAL}			return NOT_EQUAL;

. return *yytext;

"/*"         BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);

"//"[^\n]*

%%
/*
int main() {
    cout<<"\n";
    yylex();
    cout<<"\n";
} */