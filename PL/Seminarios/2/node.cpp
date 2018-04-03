#include <string.h>
#include <iostream>
#include <typeinfo>
#include "node.h"
#include "tokens.h"
using namespace Tree;
int yyparse();

Tree::InternalNode::InternalNode(int e, Node* p1, Node* p2){

	label = e;
	pn1 = p1;
	pn2 = p2;
}

Tree::UniqueNode::UniqueNode(int e, Node* p1){
	label = e;
	pn1 = p1;
}

Tree::NodeId::NodeId(std::string n){
	name = n;
}

Tree::NodeNum::NodeNum(int v){
	value = v;
};

void Tree::InternalNode::escribe(int level, bool old, bool ne){

	std::cout << Tree::esp(level, old, ne) << " node (" << label << ")" << std::endl;
	pn1 -> escribe(level + 2, ne, true);
	pn2 -> escribe(level + 2, ne, false);
}

void Tree::UniqueNode::escribe(int level, bool old, bool ne){

	std::cout << Tree::esp(level, old, ne) << " node (" << label << ")" << std::endl;
	pn1 -> escribe(level + 2, ne, true);
}

void Tree::NodeId::escribe(int level, bool old, bool ne){

	std::cout << Tree::esp(level, old, ne) << " ID (" << name << ")" << std::endl;
}

void Tree::NodeNum::escribe(int level, bool old, bool ne){

	std::cout << Tree::esp(level, old, ne) << " NUM (" << value << ")" << std::endl;
}

char line[Tree::Max + 1] = {0};

char* Tree::esp(int level, bool old, bool ne){
	int i;
	if(level > 1)
		if (old)
			strcpy(line + (level - 2), "| ");
		else
		    strcpy(line + (level - 2), " ");
	if(ne)
		strcpy(line + level, "|-->");
	else
		strcpy(line + level, "|L -->");

	return line;
}
using namespace Errors;

Errors::TokenError::TokenError(std::string msg, int ta, std::string lex){
	message = msg;
	ActToken = ta;
	lexema = lex;
}

Errors::NoCuadra::NoCuadra(int t, int ta, std::string lex){
	LookedForToken = t;
	ActToken = ta;
	lexema = lex;
}