typedef union{
	char *name;
	int value;
	Tree::Node* point;
}YYSTYPE;

#define ID 257
#define NUMBER 258
#define ASIGN 259

extern YYSTYPE yylval;