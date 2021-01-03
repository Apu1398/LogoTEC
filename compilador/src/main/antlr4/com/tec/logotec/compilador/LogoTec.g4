grammar LogoTec;

@parser::header {
	import java.util.Map;
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import java.awt.TextArea;
	import com.tec.logotec.compilador.ast.*;
	import com.tec.logotec.compilador.turtle.*;
}

@parser::members {
	Map<String, Object> symbolTable = new HashMap<String, Object>();
	private TextArea consoleOutput;
	Turtle theTurtle;
	World theWorld;
	
	public LogoTecParser(TokenStream input, TextArea consoleOutput, Turtle turtle, World world){
		this(input);
		this.consoleOutput = consoleOutput;
		this.theTurtle = turtle;
		this.theWorld = world;
		this.theTurtle.goTo(0, 0);
		this.theWorld.eraseGround();
		this.theTurtle.goTo(0,0);
		this.theTurtle.setHeading(0);
	}
	Map<String, Object> symbolTable2 = new HashMap<String, Object>();
}

program:
	DEFINE ID PAR_OPEN ID? PAR_CLOSE
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
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
	| avanza            {$node = $avanza.node;		   }
	| retrocede         {$node = $retrocede.node;      }
	| giraderecha       {$node = $giraderecha.node;    }
	| giraizquierda     {$node = $giraizquierda.node;  }
	| ponpos		    {$node = $ponpos.node;         }
	| ponrumbo		    {$node = $ponrumbo.node;       }
	| rumbo		   		{$node = $rumbo.node;          }
	| pongoma   		{$node = $pongoma.node;        }
	| quitagoma	   		{$node = $quitagoma.node;      }
	| bajalapiz   		{$node = $bajalapiz.node;      }
	| subelapiz   		{$node = $subelapiz.node;      }
	| poncolorlapiz     {$node = $poncolorlapiz.node;  }
	| centro            {$node = $centro.node;         }
	| espera            {$node = $espera.node;         }
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
		$node  = new Println($expression.node, consoleOutput);
	};


avanza returns [ASTNode node]: AVANZA expression SEMICOLON{
			$node = new Avanza($expression.node, theTurtle);
};

retrocede returns [ASTNode node]: RETROCEDE expression SEMICOLON{
			$node = new Retrocede($expression.node, theTurtle);
};

giraderecha returns [ASTNode node]: GIRADERECHA expression SEMICOLON{
			$node = new GiraDerecha($expression.node, theTurtle);
};

giraizquierda returns [ASTNode node]: GIRAIZQUIERDA expression SEMICOLON{
			$node = new GiraIzquierda($expression.node, theTurtle);
};

ponpos returns [ASTNode node]: 
			(PONPOS CUAD_OPEN t1 = expression t2=expression CUAD_CLOSE SEMICOLON
		    |
		    PONPOS t1=expression t2=expression SEMICOLON) {
		    	$node = new PonPos($t1.node, $t2.node, theTurtle);
		    };
		    
ponrumbo returns [ASTNode node]: PONRUMBO expression SEMICOLON{
			$node = new PonRumbo($expression.node, theTurtle);
};


rumbo returns [ASTNode node]: RUMBO SEMICOLON{
			$node = new Rumbo(theTurtle);
};


ponx returns [ASTNode node]: PONX expression SEMICOLON{
			$node = new PonX($expression.node, theTurtle);
};

pony returns [ASTNode node]: PONY expression SEMICOLON{
			$node = new PonY($expression.node, theTurtle);
};

pongoma returns [ASTNode node]: PONGOMA SEMICOLON{
			$node = new PonGoma(theTurtle);
};

quitagoma returns [ASTNode node]: QUITAGOMA SEMICOLON{
			$node = new QuitaGoma(theTurtle);
};

bajalapiz returns [ASTNode node]: BAJALAPIZ SEMICOLON{
			$node = new BajaLapiz(theTurtle);
};

subelapiz returns [ASTNode node]: SUBELAPIZ SEMICOLON{
			$node = new SubeLapiz(theTurtle);
};

poncolorlapiz returns [ASTNode node]: PONCOLORLAPIZ COLOR SEMICOLON{
	        $node = new PonColorLapiz($COLOR.text,theTurtle);
};

centro returns [ASTNode node]: CENTRO SEMICOLON{
	        $node = new Centro(theTurtle);
};	  

espera returns [ASTNode node]: ESPERA expression SEMICOLON{
			$node = new Espera($expression.node, theTurtle);
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
		 |DIF C2=expression {$node = new Different($C1.node,$C2.node);}
		 |NOT C2=expression {$node = new Not($C2.node);})*;	
	
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
AVANZA:'avanza' | 'av'; 
RETROCEDE:'retrocede' | 're';
GIRADERECHA: 'giraderecha' | 'gd';
GIRAIZQUIERDA: 'giraizquierda' | 'gi'; 
PONPOS: 'ponpos' | 'ponxy';
PONRUMBO: 'ponrumbo';
RUMBO: 'rumbo';
PONX: 'ponx';
PONY: 'pony';
PONGOMA: 'goma' | 'go';
QUITAGOMA: 'quitagoma';
BAJALAPIZ: 'bajalapiz' | 'bl';
SUBELAPIZ: 'subelapiz' | 'sb';
PONCOLORLAPIZ: 'poncolorlapiz'|'poncl';
CENTRO: 'centro';
ESPERA: 'espera';


IF: 'if';
ELSE: 'else';
WHILE: 'while';


COLOR: 'blanco' | 'azul' | 'marron' | 'cian' | 'gris' | 'amarillo' | 'negro' | 'rojo' | 'verde';

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

CUAD_OPEN: '[';
CUAD_CLOSE: ']';

SEMICOLON: ';';

BOOLEAN: 'true' | 'false';

ID: [a-zA-Z_][a-zA-Z0-9_]*;

STRING: ["a-zA-Z_][a-zA-Z0-9_"]+;
NUMBER: [0-9]+;

WS
:
	[ \t\r\n]+ -> skip
;