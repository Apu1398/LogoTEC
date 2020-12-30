grammar LogoTec;

@parser::header {
	import java.util.Map;
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import com.tec.logotec.compilador.ast.*;
}

@parser::members {
	Map<String, Object> symbolTable = new HashMap<String, Object>();
}

program:
	DEFINE ID PAR_OPEN ID? PAR_CLOSE
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
		//Se crea aca pues este es el punto de entrada de la BNF
		Map<String, Object> symbolTable = new HashMap<String, Object>(); 
	} 
	BRACKET_OPEN 
	( statement { body.add($statement.node); } )*
	BRACKET_CLOSE
	{
		for(ASTNode statement: body){
			statement.execute(symbolTable);
		}
	}
;

statement returns [ASTNode node]: 
	  var_declaration	{$node = $var_declaration.node;}
	| var_assignment	{$node = $var_assignment.node; }
	| conditional 		{$node = $conditional.node;    }
	| loop 		  		{$node = $loop.node;           }
	| println 	  		{$node = $println.node;        }
;


var_declaration returns [ASTNode node]: 
	TYPE ID SEMICOLON
	{
		$node = new VarDeclaration($ID.text);
	}
;
	
	
var_assignment returns [ASTNode node]: 
	ID ASSIGN expression SEMICOLON
	{
		$node = new VarAssignment($ID.text, $expression.node);
	}
;


conditional returns [ASTNode node]: 
	IF PAR_OPEN logic PAR_CLOSE 
	{
		List<ASTNode> ifBody = new ArrayList<ASTNode>();
	}
	BRACKET_OPEN 
	( s1=statement { ifBody.add($s1.node); } )* 
	BRACKET_CLOSE
	
	ELSE
	{
		List<ASTNode> elseBody = new ArrayList<ASTNode>();
	} 
	BRACKET_OPEN 
	( s2=statement { elseBody.add($s2.node); } )* 
	BRACKET_CLOSE	
	
	{
		$node = new Conditional($logic.node, ifBody, elseBody);
	}
;
	
loop returns [ASTNode node]:
	WHILE PAR_OPEN logic PAR_CLOSE 
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
	}
	BRACKET_OPEN 
	( statement { body.add($statement.node); } )*   
	BRACKET_CLOSE
	{
		$node = new Loop($logic.node, body);
	}
;
	


println returns [ASTNode node]: 
	PRINTLN expression SEMICOLON
	{
		$node  = new Println($expression.node);
	};

logic returns [ASTNode node]:
		 f1=comparison {$node = $f1.node;}
		 (
		 AND f2=comparison {$node = new And($f1.node,$f2.node);}
		 |
		 OR f2=comparison {$node = new Or($f1.node,$f2.node);}
		 )*
;
	  		 	
comparison returns [ASTNode node]:
		 C1=expression {$node = $C1.node;}
		 (GT C2=expression {$node = new Greater($C1.node,$C2.node);}
		 |LT C2=expression {$node = new Lower($C1.node,$C2.node);}
		 |GEQ C2=expression {$node = new GreaterEqual($C1.node,$C2.node);}
		 |LEQ C2=expression {$node = new LowerEqual($C1.node,$C2.node);}
		 |EQ C2=expression {$node = new Equal($C1.node,$C2.node);}
		 |DIF C2=expression {$node = new Different($C1.node,$C2.node);})
		 |NOT C2=expression {$node = new Not($C2.node);}
		 
;	
	
expression returns [ASTNode node]:
	t1=factor {$node = $t1.node;} 
	(
	(PLUS t2=factor {$node = new Addition($node, $t2.node);})
	| 
	(MINUS t2=factor {$node = new Subtraction($node, $t2.node);})
	)*   
;

factor returns [ASTNode node]: 
	t1=term {$node = $t1.node;} 
	(
	(MULT t2=term {$node = new Multiplication($node, $t2.node);})
	|
	(DIV t2=term  {$node = new Division($node, $t2.node);})
	)*
;
	
	
term returns [ASTNode node]:
	ID 
	{
	 	$node = new VarReference($ID.text);
	}
	|NUMBER 
	{
	 	$node = new Constant(Integer.parseInt($NUMBER.text));
	} 
	|STRING
	{
		$node = new Constant($STRING.text);	
	}
	|BOOLEAN
	{
		$node = new Constant(Boolean.parseBoolean($BOOLEAN.text));
	}
	| PAR_OPEN 
	  expression { $node = $expression.node; }
	  PAR_CLOSE
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
DIF: '!=';

ASSIGN: '=';

BRACKET_OPEN: '{';
BRACKET_CLOSE: '}';

PAR_OPEN: '(';
PAR_CLOSE: ')';

SEMICOLON: ';';

BOOLEAN: 'true' | 'false';

ID: [a-zA-Z_][a-zA-Z0-9_]*;

STRING: ["a-zA-Z_][a-zA-Z0-9_"]+;
NUMBER: [0-9]+;

WS
:
	[ \t\r\n]+ -> skip
;