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
	| var_assignment
	| conditional
	| loop
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
	IF PAR_OPEN expression PAR_CLOSE BRACKET_OPEN 
	statement* 
	BRACKET_CLOSE
	(
	ELSE BRACKET_OPEN 
	statement* 
	BRACKET_CLOSE	
	)?
;
	
loop:
	WHILE PAR_OPEN NUMBER PAR_CLOSE BRACKET_OPEN 
	statement*   
	BRACKET_CLOSE
;
	
function_call:
	ID PAR_OPEN (NUMBER)? PAR_CLOSE SEMICOLON
;


println: 
	PRINTLN expression SEMICOLON
	{
		System.out.println($expression.value);
	};
	
	
expression returns [Object value]:
	t1=factor {$value = (int)$t1.value;} 
	(
	(PLUS t2=factor {$value = (int)$value + (int)$t2.value;})
	|
	(MINUS t2=factor  {$value = (int)$value - (int)$t2.value;})
	)*
;

factor returns [Object value]: 
	t1=term {$value = (int)$t1.value;} 
	(
	(MULT t2=term {$value = (int)$value * (int)$t2.value;})
	|
	(DIV t2=term  {$value = (int)$value / (int)$t2.value;})
	)*
;
	
term returns [Object value]:
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
		$value = Boolean.parseBoolean($BOOLEAN.text);
	}
	| PAR_OPEN expression PAR_CLOSE
;





DEFINE: 'define';
TYPE: 'int' |'String'| 'bool';
PRINTLN: 'println';

IF: 'if';
ELSE: 'else';
WHILE: 'while';



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

BOOLEAN: 'true' | 'false';
STRING: ["a-zA-Z_][a-zA-Z0-9_"]+;
NUMBER: [0-9]+;

WS
:
	[ \t\r\n]+ -> skip
;