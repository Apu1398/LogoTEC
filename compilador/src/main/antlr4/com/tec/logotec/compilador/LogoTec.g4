grammar LogoTec;


program: PROGRAM ID BRACKET_OPEN 
	sentence*
	BRACKET_CLOSE;
	
sentence: var_decl | var_assign | println;

var_decl: VAR ID SEMICOLON
	{System.out.println("Var");};
var_assign: ID ASSIGN expression SEMICOLON
	{System.out.println("Assign");};
println: PRINTLN expression SEMICOLON
	{System.out.println("print");};
expression: NUMBER | ID;


PROGRAM: 'program';
VAR: 'var';
PRINTLN: 'println';

PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';

AND: '&&';
OR: '||';
NOT: '!';

GT: '>';
LT: '<';
GEQ: '>=';
LEQ: '<=';
EQ: '==';
NEQ: '!=';

ASSIGN: '=';

BRACKET_OPEN: '{';
BRACKET_CLOSE: '}';

PAR_OPEN: '(';
PAR_CLOSE: ')';

SEMICOLON: ';';

ID: [a-zA-Z_][a-zA-Z0-9_]*;

NUMBER: [0-9]+;

WS
:
	[ \t\r\n]+ -> skip
;