


grammar LogoTec;

@parser::header {
	import java.util.Map;
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import com.tec.logotec.compilador.ast.*;
	import com.tec.logotec.compilador.turtle.*;
	import java.awt.TextArea;
}

@parser::members {
	Map<String, Object> symbolTable2 = new HashMap<String, Object>();
	TextArea consoleOutput;
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
}


program:
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
		Context symbolTable = new Context();
	} 
	(COMMENT
	|
	LINE_COMMENT
	)
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
	| comment  			{$node = $comment.node;	       }
	| var_init			{$node = $var_init.node; 	   }
	| if_ifelse 		{$node = $if_ifelse.node;      }
	| if_cond			{$node = $if_cond.node;		   }
	| loop 		  		{$node = $loop.node;           }
	| repite 		  	{$node = $repite.node;         }
	| doWhile			{$node = $doWhile.node;        }
	| println 	  		{$node = $println.node;        }
	| avanza            {$node = $avanza.node;		   }
	| retrocede         {$node = $retrocede.node;      }
	| giraderecha       {$node = $giraderecha.node;    }
	| giraizquierda     {$node = $giraizquierda.node;  }
	| ponpos		    {$node = $ponpos.node;         }
	| ponrumbo		    {$node = $ponrumbo.node;       }
	| pongoma   		{$node = $pongoma.node;        }
	| quitagoma	   		{$node = $quitagoma.node;      }
	| bajalapiz   		{$node = $bajalapiz.node;      }
	| subelapiz   		{$node = $subelapiz.node;      }
	| poncolorlapiz     {$node = $poncolorlapiz.node;  }
	| centro            {$node = $centro.node;         }
	| espera            {$node = $espera.node;         }
;

function returns [ASTNode node]:
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
		List<String> parameters = new ArrayList<String>();
	}
	DEFINE funcName=ID PAR_OPEN (par1=ID{parameters.add($par1.text);} (COMMA par2=ID{parameters.add($par2.text);})*)? PAR_CLOSE 
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

	 ID PAR_OPEN (t1=expression{parameters.add($t1.node);} (COMMA t2=expression{parameters.add($t2.node);})*)? PAR_CLOSE 
	{$node = new FunctionCall($ID.text,parameters); }
;


comment returns [ASTNode node]:
	(COMMENT
	|
	LINE_COMMENT){
		$node = new Comment();
	};
	

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
	WHILE PAR_OPEN logic PAR_CLOSE 
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
	DOWHILE
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
	

avanza returns [ASTNode node]: AVANZA expression {
			$node = new Avanza($expression.node, theTurtle);
};

retrocede returns [ASTNode node]: RETROCEDE expression {
			$node = new Retrocede($expression.node, theTurtle);
};

giraderecha returns [ASTNode node]: GIRADERECHA expression {
			$node = new GiraDerecha($expression.node, theTurtle);
};

giraizquierda returns [ASTNode node]: GIRAIZQUIERDA expression {
			$node = new GiraIzquierda($expression.node, theTurtle);
};

ponpos returns [ASTNode node]: 
			(PONPOS OPEN_SQUARE_BRACKET t1 = expression t2=expression CLOSE_SQUARE_BRACKET
		    |
		    PONPOS t1=expression t2=expression) {
		    	$node = new PonPos($t1.node, $t2.node, theTurtle);
		    };
		    
ponrumbo returns [ASTNode node]: PONRUMBO expression {
			$node = new PonRumbo($expression.node, theTurtle);
};

/*
rumbo returns [ASTNode node]: RUMBO {
			$node = new Rumbo(theTurtle);
};*/


ponx returns [ASTNode node]: PONX expression {
			$node = new PonX($expression.node, theTurtle);
};

pony returns [ASTNode node]: PONY expression {
			$node = new PonY($expression.node, theTurtle);
};

pongoma returns [ASTNode node]: PONGOMA {
			$node = new PonGoma(theTurtle);
};

quitagoma returns [ASTNode node]: QUITAGOMA {
			$node = new QuitaGoma(theTurtle);
};

bajalapiz returns [ASTNode node]: BAJALAPIZ {
			$node = new BajaLapiz(theTurtle);
};

subelapiz returns [ASTNode node]: SUBELAPIZ {
			$node = new SubeLapiz(theTurtle);
};

poncolorlapiz returns [ASTNode node]: PONCOLORLAPIZ COLOR {
	        $node = new PonColorLapiz($COLOR.text,theTurtle);
};

centro returns [ASTNode node]: CENTRO {
	        $node = new Centro(theTurtle);
};	  

espera returns [ASTNode node]: ESPERA expression {
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
		 (
		 (
		  GT  C2=expression {$node = new Greater($C1.node,$C2.node);     }
		 |LT  C2=expression {$node = new Lower($C1.node,$C2.node);       }
		 |GEQ C2=expression {$node = new GreaterEqual($C1.node,$C2.node);}
		 |LEQ C2=expression {$node = new LowerEqual($C1.node,$C2.node);  }
		 |EQ  C2=expression {$node = new Equal($C1.node,$C2.node);       }
		 |DIF C2=expression {$node = new Different($C1.node,$C2.node);   }
		 )
		 |NOT C2=expression {$node = new Not($C2.node);                  }
		 )*	 
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
	
	|RUMBO
	{
		$node = new Constant( Math.round(theTurtle.getHeading()));
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


AVANZA:'avanza' | 'av'; 
RETROCEDE:'retrocede' | 're';
GIRADERECHA: 'giraderecha' | 'gd';
GIRAIZQUIERDA: 'giraizquierda' | 'gi'; 
PONPOS: 'ponpos' | 'ponxy';
RUMBO: 'rumbo';
PONRUMBO: 'ponrumbo';
PONX: 'ponx';
PONY: 'pony';
PONGOMA: 'goma' | 'go';
QUITAGOMA: 'quitagoma';
BAJALAPIZ: 'bajalapiz' | 'bl';
SUBELAPIZ: 'subelapiz' | 'sb';
PONCOLORLAPIZ: 'poncolorlapiz'|'poncl';
CENTRO: 'centro';
ESPERA: 'espera';

COLOR: 'blanco' | 'azul' | 'marron' | 'cian' | 'gris' | 'amarillo' | 'negro' | 'rojo' | 'verde';

IFELSE: 'SiSino';
IF: 'Si';
//ELSE: 'else';
WHILE: 'while';
REPITE: 'repite';
DOWHILE: 'HazMientras';

DO: 'Haz';
INIC: 'Inic';


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
: '/*' .*? '*/' 
;
LINE_COMMENT
: '//' ~[\r\n]* 
;
