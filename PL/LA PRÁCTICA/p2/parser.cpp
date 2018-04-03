#include <iostream>
#include <string>
#include <map>
using namespace std;

#include "lex.yy.c"

map <string,bool> tabla;
void cuadra(int obj);
void yyerror(const string & msj);
int yylex(void);
extern char * yytext;

void	begin(void);
void	expr(void);
bool	ar_expr (void);
bool	ar_exprP (bool b);
bool  	conc(void);
bool  	concP(bool b);
bool    disy(void);


int ta;
string * yylval;

void begin (void){
	if (ta == ID){
		expr();
		if (ta == SEMICOLON){
			cuadra(SEMICOLON);
			begin();
		}else{ 
			yyerror("en punto y coma");
		}
		
	}else{
		if(ta == PRINT){
			cuadra(PRINT);
			cout << "Resultado es "<<ar_expr()<<endl;
			if (ta == SEMICOLON){
				cuadra(SEMICOLON);
				begin();
			}else{ 
				yyerror("en punto y coma");
			}
		}else{
			if (ta == 0) // 0 es el fin de archivo para flex
				return;  // entrada -> epsilon
			else
            yyerror("en begin");
		}		
    }
} // fin de begin()

void expr (void){
	if (ta == ID){
		string *IDlexval = yylval;
		cuadra(ID);
		if(ta == EQUAL){		
			cuadra(EQUAL); 	
			tabla[*IDlexval]= ar_expr();
		}else
			yyerror("en ID EQUAL ar_expr"); 
	}else{

		if(ta == PRINT){

		}else
			yyerror("en expr");

	}
} //fin de expr()

bool ar_expr(void){
	if(ta == NOT || ta == ID || ta == TRUE || ta == FALSE || ta == OP_BK || ta == CL_BK){
		bool b1 = conc();
		return ar_exprP(b1);
	}else
		yyerror("en ar_expr");
} //fin de ar_expr()


bool ar_exprP(bool b){
	if(ta == OR){
		cuadra(OR);
		bool b1 = conc();
		return b or b1;
	}else{
		if(ta == SEMICOLON){
			return b; 
		}else
			yyerror("en ar_exprP");
	}
}//fin de ar_exprP()
bool conc (void){
	if(ta == NOT || ta == ID || ta == TRUE || ta == FALSE || ta == OP_BK){
		bool b1 = disy();
		return concP(b1);
	}else
		yyerror("en conc");
} //fin de conc()

bool disy(void){
	if(ta == NOT){
		cuadra(NOT);
		return !disy();
	}else{
		if(ta == ID){
			string *IDlexval = yylval;
			cuadra(ID);
			if(tabla.find(*IDlexval)!= tabla.end()){
				return tabla[*IDlexval];
			}else
				yyerror("en disy, no se ha declarado una variable");
		}else{
			if(ta == TRUE){
				cuadra(TRUE);
				return true;
			}else{
				if(ta == FALSE){
					cuadra(FALSE);
					return false;
				}else{
					if(ta == OP_BK){
						cuadra(OP_BK);
						return ar_expr();
					}else
						yyerror("en disy");
				}
			}
		}
	}
} //fin de disy()

bool concP(bool b){
	if(ta == AND){
		cuadra(AND);
		bool b1 = concP(disy());
		return b and b1; 
	}else{
		if(ta == SEMICOLON || ta == OR){
			return b;
		}else{
			if(ta == CL_BK){
				cuadra(CL_BK);
				return b;
			}else{
				yyerror("en concP");
			}
		}
			
	}
} //fin de concP()


int main() {

ta = yylex();
begin();

cout << "Final del programa\n";
}//fin del main()

void yyerror(const string & msj) {

	cerr << "error sintactico " << msj << endl;
	exit(EXIT_FAILURE);

} // fin de yyerror()

void cuadra(int obj) {

	if (ta == obj){
	/*cout << "cuadro ta=" << ta << " (" << yytext << ")";*/
	ta = yylex();
	/*cout << " ==> nuevo ta=" << ta << " (" << yytext << ")\n";*/

	}else yyerror("en cuadra");

} // fin de cuadra()