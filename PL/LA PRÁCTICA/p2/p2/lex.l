%{
#include <iostream>
#include <string>
#include <algorithm>

//#include "parser.tab.h"
using namespace std;


#define EQUAL 258
#define TRUE  259
#define FALSE 260
#define AND   261
#define OR    262
#define NOT   263
#define PRINT 264
#define ID    265
#define SEMICOLON  266
#define OP_BK  267
#define CL_BK  268

extern string * yylval;
%}



EQUAL				":="
TRUE				"true"
FALSE				"false"
AND					"and"
OR   				"or"
NOT					"not"
PRINT				"print"
SEMICOLON           ";"
OP_BK               "("
CL_BK               ")"

ID 					[a-zA-Z_][a-zA-Z0-9_A-Z]*


%option noyywrap

%%

[ \n\t]				;
{EQUAL}				return EQUAL;
{TRUE}				return TRUE;
{FALSE}				return FALSE;
{AND}				return AND;
{OR}				return OR;
{NOT}				return NOT;
{PRINT}				return PRINT;
{ID}				{yylval= new string(yytext); return ID;}
{SEMICOLON}		    return SEMICOLON;
{OP_BK}             return OP_BK;
{CL_BK}				return CL_BK;
.
%%
/*
int main() {
    cout<<"\n";
    yylex();
    cout<<"\n";
} */