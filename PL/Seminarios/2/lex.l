%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include "node.h"
#include "tokens.h"
%}

id [a-zA-Z_][a-zA-Z0-9_]*

%%

[ \n\t] ;
":=" return ASIGN;
[0-9]+ {sscanf(yytext, "%d", &yylval.value); return NUMBER;}
{id} {yylval.name = (char*)malloc(strlen(yytext)+1); strcpy(yylval.name, yytext); return ID;}
. return *yytext;

%%