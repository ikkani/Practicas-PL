#include <iostream>
#include <cstdlib>
#include <string>
#include "node.h"
#include "tokens.h"




YYSTYPE yylval;
using namespace Tree;
using namespace Errors;

void entrada(void);
Tree::Node* E(void);
Tree::Node* Re(Node*);
Tree::Node* T(void);
Tree::Node* Rt(Node*);
Tree::Node* P(void);
Tree::Node* Rp(Node*);
Tree::Node* F(void);

extern int yylex(void);
extern char* yytext;
int ta;

void cuadra(int t){
	if(ta == t)
		ta = yylex();
	else
		throw Errors::NoCuadra(t, ta, std::string(yytext));
}

void entrada(void){
	Tree::Node *es, *es1;
	if(ta == ID){
		char* na = yylval.name;
		
		try{
			cuadra(ID);
			cuadra(ASIGN);
			es = E();
			es1 = new Tree::InternalNode('=', new Tree::NodeId(std::string(na)), es);
			es1 -> escribe(0,false, false);
		}catch(Errors::NoCuadra & e){
			std::cerr 	<< "Error:No cuadra,token que busco = " << e.LookedForToken << "pero hay =	" 
					<< e.ActToken << " (" << e.lexema << ")Salta hasta ;" << std::endl;
			while((ta==yylex()) != ';' && ta != 0);
		}catch(Errors::TokenError & e){
			std::cerr 	<< "Error: " << e.message << "token actual = " << e.ActToken 
			<< " (" << e.lexema << ")Salta hasta ;" << std::endl;
			while((ta==yylex()) != ';' && ta != 0);
		}
			cuadra(';');
			entrada();
		}
	else if(ta != 0)
		throw Errors::TokenError("en entrada: espera fin de archivo", ta, std::string(yytext));
}//end of entrada

Node* E(void){
	Tree::Node *t_s, *e_s;
	if(ta == NUMBER || ta == ID || ta == '-' || ta == '(') {
		t_s = T();
		e_s = Re(t_s);
		return e_s;
	}
	else
		throw Errors::TokenError("en E", ta, std::string(yytext));
}	//end of E

Node* Re(Node* re_h){
	Tree::Node *t_s, *re1_h, *re_s;
	if(ta == '+'){
		cuadra('+');
		t_s = T();
		re1_h = new Tree::InternalNode('+',re_h, t_s);
		re_s = Re(re1_h);
		return re_s;
	}
	else if(ta == '-'){
		cuadra('-');
		t_s = T();
		re1_h = new Tree::InternalNode('-',re_h, t_s);
		re_s = Re(re1_h);
		return re_s;
		}
	else
	return re_h;
}//end of Re

Node* T(void){
Tree::Node *p_s, *t_s;
if(ta == NUMBER || ta == ID || ta == '-' || ta == '('){
	p_s = P();
	t_s = Rt(p_s);
	return t_s;
}
else
	throw Errors::TokenError("En T", ta, std::string(yytext));
}//end of T

Node* Rt(Node* rt_h){
Tree::Node *p_s, *rt1_h, *rt_s;
if(ta == '*'){
	cuadra('*');
	p_s = P();
	rt1_h = new Tree::InternalNode('*', rt_h, p_s);
	rt_s = Rt(rt1_h);
	return rt_s;
}
else if(ta == '/'){
	cuadra('/');
	p_s = P();
	rt1_h = new Tree::InternalNode('/', rt_h, p_s);
	rt_s = Rt(rt1_h);
	return rt_s;
}
else
	return rt_h;
}//end of Rt

Node* P(void){
Tree::Node *p_s, *f_s;
if(ta == NUMBER || ta == ID || ta == '-' || ta == '('){
	f_s = F();
	p_s = Rp(f_s);
	return p_s;
}
else
	throw Errors::TokenError("En P", ta, std::string(yytext));
}//end of P
Node* Rp(Node* rp_h){
Tree::Node *f_s, *rp1_s, *rp_s;
if(ta == '^'){
	cuadra('^');
	f_s = F();
	rp1_s = Rp(f_s);
	rp_s = new Tree::InternalNode('^', rp_h, rp1_s);
	return rp_s;
}else
	return rp_h;
}//end of Rp

Node* F(void){
Tree::Node * f_s, *f1_s;
if
(ta == NUMBER){
	f_s = new Tree::NodeNum(yylval.value);
	cuadra(NUMBER);
	return f_s;
}else if (ta == ID){
	f_s = new Tree::NodeId(yylval.name);
	cuadra(ID);
	return f_s;
}else if (ta == '('){
	cuadra('(');
	f_s = E();
	cuadra(')');
	return f_s;
}else if (ta == '-'){
	cuadra('-');
	f1_s = F();
	f_s = new Tree::UniqueNode('~',f1_s);
	return f_s;
}
else
	throw Errors::TokenError("En F", ta, std::string(yytext));
}// end of F

int main(){
	std::cout << "Comienza el programa" << std::endl;
	std::cout << "Teclee expresiones aritmeticas terminadas en punto y coma" << std::endl;
	ta = yylex();
	try{
	entrada();
	}
	catch(Errors::NoCuadra & e){
	std::cerr << "Error:No cuadra,token que busco = " << e.LookedForToken 
	 << "pero hay = " << e.ActToken << " (" << e.lexema << ")Fin del programa" << std::endl;
	exit(EXIT_FAILURE);
	}
	catch(Errors::TokenError & e){
	std::cerr << "Error: " << e.message << "token actual = " << e.ActToken << " (" <<
	e.lexema << ")Final del programa" << std::endl;
	exit(EXIT_FAILURE);
	}
	std::cout << "Fin del programa" << std::endl;
}//end of main()