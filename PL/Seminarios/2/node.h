#ifndef NODE_H
#define NODE_H

#include <string>

namespace Tree {

	class Node{

		public:
		Node(void){}
		virtual void escribe(int level, bool old, bool ne){}
	};

	class InternalNode: public Node{

		char label;
		Node *pn1;
		Node *pn2;
		public:
		InternalNode(int, Node*, Node*);
		void escribe(int level, bool old, bool ne);
	};

	class UniqueNode : public Node
	{
		char label;
		Node* pn1;
		public:
		UniqueNode(int, Node*);
		void escribe(int level, bool old, bool ne);
	};

	class NodeId: public Node
	{
		std::string name;
		public:
		NodeId(std::string);
		void escribe(int level, bool old, bool ne);
	};

	class NodeNum: public Node
	{
		int value;
		public:
		NodeNum(int);
		void escribe(int level, bool old, bool ne);
	};

	const int Max = 80;

	char* esp(int level, bool old, bool ne);
	} //end namespace "Tree"

namespace Errors{

	struct TokenError{

		std::string message;
		int ActToken;
		std::string lexema;
		TokenError(std::string msg, int ta, std::string lex);
	};
	struct NoCuadra{
		int LookedForToken;
		int ActToken;
		std::string lexema;
		NoCuadra(int t, int ta, std::string lex);
    };
} // End of namespace “Errors”

#endif