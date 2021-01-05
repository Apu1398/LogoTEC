grammar LogoTec;

@parser::header {
	import java.util.Map;
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import com.tec.logotec.compilador.ast.*;
}

@parser::members {
	Map<String, Object> symbolTable2 = new HashMap<String, Object>();
}


program:
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
		Context symbolTable = new Context();
	} 
	( statement { body.add($statement.node);} )*
	{
		for(ASTNode statement: body){
			statement.execute(symbolTable);
		}
	}
;


statement returns [ASTNode node]: 
	  function			{$node = $function.node;	   }
	| function_call		{$node = $function_call.node;  }
	//| var_declaration	{$node = $var_declaration.node;}
	| var_assignment	{$node = $var_assignment.node; }
	| var_init			{$node = $var_init.node; 	   }
	| if_ifelse 		{$node = $if_ifelse.node;      }
	| if_cond			{$node = $if_cond.node;		   }
	| loop 		  		{$node = $loop.node;           }
	| repite 		  	{$node = $repite.node;         }
	| doWhile			{$node = $doWhile.node;        }
	| println 	  		{$node = $println.node;        }
;

function returns [ASTNode node]:
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
		List<String> parameters = new ArrayList<String>();
	}
	DEFINE funcName=ID OPEN_SQUARE_BRACKET (par1=ID{parameters.add($par1.text);} (par2=ID{parameters.add($par2.text);})*)? CLOSE_SQUARE_BRACKET 
	OPEN_SQUARE_BRACKET 
	( statement { body.add($statement.node); } )*
	CLOSE_SQUARE_BRACKET
	END_DEFINE
	{
		$node = new Function($funcName.text, parameters, body); 
	}
;


function_call returns [ASTNode node]
:
	{
		List<ASTNode> parameters = new ArrayList<ASTNode>();
	}

	 ID OPEN_SQUARE_BRACKET (t1=expression{parameters.add($t1.node);} (t2=expression{parameters.add($t2.node);})*)? CLOSE_SQUARE_BRACKET 
	{$node = new FunctionCall($ID.text,parameters); }
;

/*
var_declaration returns [ASTNode node]: 
	TYPE ID 
	{
		$node = new VarDeclaration($ID.text);
	}
;
*/

		
var_init returns [ASTNode node]: 
	DO ID expression 
	{
		$node = new VarInitialization($ID.text, $expression.node);
	}
;

	
var_assignment returns [ASTNode node]: 
	INIC ID ASSIGN expression 
	{
		$node = new VarAssignment($ID.text, $expression.node);
	}
;


if_ifelse returns [ASTNode node]: 
	IFELSE PAR_OPEN logic PAR_CLOSE 
	{
		List<ASTNode> ifBody = new ArrayList<ASTNode>();
	}
	OPEN_SQUARE_BRACKET 
	( s1=statement { ifBody.add($s1.node); } )* 
	CLOSE_SQUARE_BRACKET
	{
		List<ASTNode> elseBody = new ArrayList<ASTNode>();
	} 
	OPEN_SQUARE_BRACKET 
	( s2=statement { elseBody.add($s2.node); } )* 
	CLOSE_SQUARE_BRACKET	
	
	{
		$node = new Conditional($logic.node, ifBody, elseBody);
	}
;

if_cond returns [ASTNode node]: 
	IF PAR_OPEN logic PAR_CLOSE 
	{
		List<ASTNode> ifBody = new ArrayList<ASTNode>();
	}
	OPEN_SQUARE_BRACKET 
	( s1=statement { ifBody.add($s1.node); } )* 
	CLOSE_SQUARE_BRACKET
	{
		$node = new IfConditional($logic.node, ifBody);
	}
;

	
loop returns [ASTNode node]:
	(WHILE | WHILE2) PAR_OPEN logic PAR_CLOSE 
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
	}
	OPEN_SQUARE_BRACKET 
	( statement { body.add($statement.node); } )*   
	CLOSE_SQUARE_BRACKET
	{
		$node = new Loop($logic.node, body);	
	}
;


repite returns [ASTNode node]:
	REPITE PAR_OPEN NUMBER PAR_CLOSE 
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
	}
	OPEN_SQUARE_BRACKET 
	( statement { body.add($statement.node); } )*   
	CLOSE_SQUARE_BRACKET
	{
		$node = new Repite(Integer.parseInt($NUMBER.text), body);
	}
;	

doWhile returns [ASTNode node]:
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
	}
	(DOWHILE | DOWHILE2) 
	OPEN_SQUARE_BRACKET 
	( statement { body.add($statement.node); } )*   
	CLOSE_SQUARE_BRACKET
	PAR_OPEN logic PAR_CLOSE
	{
		$node = new DoWhile($logic.node, body);	
	}
;


println returns [ASTNode node]: 
	PRINTLN expression 
	{
		$node  = new Println($expression.node);
	};

logic returns [ASTNode node]:
		 f1=comparison {$node = $f1.node;}
		 |
		 (
		 AND f1=comparison {$node = $f1.node;} f2=comparison {$node = new And($f1.node,$f2.node);}
		 |
		 OR f1=comparison {$node = $f1.node;} f2=comparison {$node = new Or($f1.node,$f2.node);}
		 )+
;
	  		 	
comparison returns [ASTNode node]:
		 C1=expression {$node = $C1.node;}
		 |
		 ( 
		  PAR_OPEN GT  C1=expression {$node = $C1.node;} C2=expression {$node = new Greater($C1.node,$C2.node);} 	  PAR_CLOSE
		 |PAR_OPEN LT  C1=expression {$node = $C1.node;} C2=expression {$node = new Lower($C1.node,$C2.node);       } PAR_CLOSE
		 |PAR_OPEN GEQ C1=expression {$node = $C1.node;} C2=expression {$node = new GreaterEqual($C1.node,$C2.node);} PAR_CLOSE
		 |PAR_OPEN LEQ C1=expression {$node = $C1.node;} C2=expression {$node = new LowerEqual($C1.node,$C2.node);  } PAR_CLOSE
		 |PAR_OPEN EQ  C1=expression {$node = $C1.node;} C2=expression {$node = new Equal($C1.node,$C2.node);       } PAR_CLOSE
		 |PAR_OPEN DIF C1=expression {$node = $C1.node;} C2=expression {$node = new Different($C1.node,$C2.node);   } PAR_CLOSE
		 )?	 
;	

/*
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
 */

 
 
expression returns [ASTNode node]:
	(t1=factor {$node = $t1.node;})
	|
	(
	(t1=factor {$node = $t1.node;})? SUMAR  t2=factor {$node = $t2.node;} (t3=expression {$node = new Addition($node, $t3.node);})+ 
	| 
	(t1=factor {$node = $t1.node;})? RESTAR  t2=factor {$node = $t2.node;} (t3=expression {$node = new Subtraction($node, $t3.node);})+ 
	)+
;


factor returns [ASTNode node]: 
	t1=term {$node = $t1.node;}
	| 
	(
	MULTI t2=term {$node = $t2.node;} (t3=expression {$node = new Multiplication($node, $t3.node);})+ 
	|
	DIVIDIR t2=term {$node = $t2.node;}  (t3=expression {$node = new Division($node, $t3.node);})+ 
	)+
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
	|MINUS NUMBER 
	{
		$node = new Constant(-Integer.parseInt($NUMBER.text));
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





DEFINE: 'PARA';
END_DEFINE: 'FIN';
//TYPE: 'int' |'String'| 'bool';
PRINTLN: 'println';

IFELSE: 'SiSino';
IF: 'Si';
//ELSE: 'else';
WHILE: 'Mientras';
WHILE2: 'Hasta';
REPITE: 'repite';
DOWHILE: 'HazMientras';
DOWHILE2: 'HazHasta';


DO: 'Haz';
INIC: 'Inic';


SUMAR: 'Sumar';
PLUS: '+';

RESTAR: 'Restar';
MINUS: '-';

MULTI: 'Multi';
MULT: '*';

DIVIDIR: 'Dividir';
DIV: '/';

AND: 'Y';
OR: 'O';
NOT: '!';

GT: 'MayorQue?';
LT: 'MenorQue?';
GEQ: 'MayorIgualQue?';
LEQ: 'MenorIgualQue?';
EQ: 'Iguales?';
DIF: 'Diferentes?';

ASSIGN: '=';
COMMA: ',';


BRACKET_OPEN: '{';
BRACKET_CLOSE: '}';

PAR_OPEN: '(';
PAR_CLOSE: ')';

OPEN_SQUARE_BRACKET: '[';
CLOSE_SQUARE_BRACKET: ']';
 
 
 
 
SEMICOLON: ';';

BOOLEAN: 'true' | 'false';

ID: [a-zA-Z_][a-zA-Z0-9_]*;

STRING: '"' ~('"')* '"';
NUMBER: [0-9]+;

WS
:
	[ \t\r\n]+ -> skip
;

COMMENT
: '/*' .*? '*/' -> skip
;
LINE_COMMENT
: '//' ~[\r\n]* -> skip
;