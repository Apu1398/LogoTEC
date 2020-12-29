grammar LogoTec;

@parser::header {
	import java.util.Map;
	import java.util.HashMap;
}

@parser::members {
	Map<String, Object> symbolTable = new HashMap<String, Object>();
}


program: definition*;

definition: function | statement;

function:
	DEFINE ID PAR_OPEN (ID)? PAR_CLOSE BRACKET_OPEN 
	statement*
	BRACKET_CLOSE
	{
		System.out.println("Func def");
	}
;

statement: 
	  var_declaration
	  {
	  	System.out.println("var decl");
	  }
	| var_assignment
	| conditional
	| loop
	  {
		System.out.println("loop");
	  }
	| function_call
	| println
;


var_declaration: 
	TYPE ID SEMICOLON
	{
		symbolTable.put($ID.text, 0);
		System.out.println("Var decl in");
	}
;
	
	
var_assignment: 
	ID ASSIGN expression SEMICOLON
	{
		symbolTable.put($ID.text, $expression.value);
		System.out.println("var assig in");
	}
;
	

conditional: 
	IF PAR_OPEN BOOLEAN PAR_CLOSE BRACKET_OPEN 
	statement* 
	BRACKET_CLOSE
	(
	ELSE BRACKET_OPEN 
	statement* 
	BRACKET_CLOSE	
	)?
	{
		System.out.println("Cond in");
	}
;
	
loop:
	WHILE PAR_OPEN NUMBER PAR_CLOSE BRACKET_OPEN 
	statement*   
	BRACKET_CLOSE
	{
		System.out.println("loop in");
	}
;
	
function_call:
	ID PAR_OPEN (NUMBER)? PAR_CLOSE SEMICOLON
	{
		System.out.println("Func call in");
	}
;


println: 
	PRINTLN expression SEMICOLON
	{
		System.out.println($expression.value);
	};
	
	
expression returns [Object value]:
	ID 
	{
	 	$value = symbolTable.get($ID.text);
	}
	|NUMBER 
	{
	 	$value = Integer.parseInt($NUMBER.text);
	} 
	|STRING
	{
		$value = $STRING.text;	
	}
	|BOOLEAN
	{
		$value = $BOOLEAN.text;
	}
;





DEFINE: 'define';
TYPE: 'int' |'String'| 'bool';
PRINTLN: 'println';

IF: 'if';
ELSE: 'else';
WHILE: 'while';
BOOLEAN: 'true' | 'false';


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

STRING: ["a-zA-Z_][a-zA-Z0-9_"]+;
NUMBER: [0-9]+;

WS
:
	[ \t\r\n]+ -> skip
;