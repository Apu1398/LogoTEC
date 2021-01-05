


grammar LogoTec;

@parser::header {
	import java.util.Map;
	import java.util.HashMap;
	import java.util.List;
	import java.util.ArrayList;
	import com.tec.logotec.compilador.ast.*;
	import com.tec.logotec.compilador.turtle.*;
	import java.awt.TextArea;
	import javax.swing.JFrame;
}

@parser::members {
	Map<String, Object> symbolTable2 = new HashMap<String, Object>();
	TextArea consoleOutput;
	Turtle theTurtle;
	World theWorld;
	JFrame ventana;
	
	
	public LogoTecParser(TokenStream input, TextArea consoleOutput, Turtle turtle, World world){
		this(input);
		this.consoleOutput = consoleOutput;
		this.theTurtle = turtle;
		this.ventana = ventana;
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
	| var_assignment	{$node = $var_assignment.node; }
	| comment  			{$node = $comment.node;	       }
	| var_init			{$node = $var_init.node; 	   }
	| println 	  		{$node = $println.node;        }
	| flowFunctions     {$node = $flowFunctions.node;  }
	| turtleFunctions   {$node = $turtleFunctions.node;}
	| operaciones       {$node = $operaciones.node;    }
;





flowFunctions returns [ASTNode node]: 	
	  if_ifelse 		{$node = $if_ifelse.node;      }
	| if_cond			{$node = $if_cond.node;		   }
	| loop 		  		{$node = $loop.node;           }
	| repite 		  	{$node = $repite.node;         }
	| doWhile			{$node = $doWhile.node;        }
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

	 ID PAR_OPEN (t1=operaciones{parameters.add($t1.node);} (COMMA t2=operaciones{parameters.add($t2.node);})*)? PAR_CLOSE 
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
	DO ID operaciones 
	{
		$node = new VarInitialization($ID.text, $operaciones.node);
	}
;

	
var_assignment returns [ASTNode node]: 
	INIC ID ASSIGN operaciones 
	{
		$node = new VarAssignment($ID.text, $operaciones.node);
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
	PRINTLN operaciones 
	{
		$node  = new Println($operaciones.node);
	};
	

turtleFunctions returns [ASTNode node]:
     avanza            {$node = $avanza.node;		   }
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
		
avanza returns [ASTNode node]: AVANZA operaciones {
			$node = new Avanza($operaciones.node, theTurtle);
			
};

retrocede returns [ASTNode node]: RETROCEDE operaciones {
			$node = new Retrocede($operaciones.node, theTurtle);
};

giraderecha returns [ASTNode node]: GIRADERECHA operaciones {
			$node = new GiraDerecha($operaciones.node, theTurtle);
};

giraizquierda returns [ASTNode node]: GIRAIZQUIERDA operaciones {
			$node = new GiraIzquierda($operaciones.node, theTurtle);
};

ponpos returns [ASTNode node]: 
			(PONPOS OPEN_SQUARE_BRACKET t1 = operaciones t2=operaciones CLOSE_SQUARE_BRACKET
		    |
		    PONPOS t1=operaciones t2=operaciones) {
		    	$node = new PonPos($t1.node, $t2.node, theTurtle);
		    };
		    
ponrumbo returns [ASTNode node]: PONRUMBO operaciones {
			$node = new PonRumbo($operaciones.node, theTurtle);
};

/*
rumbo returns [ASTNode node]: RUMBO {
			$node = new Rumbo(theTurtle);
};*/


ponx returns [ASTNode node]: PONX operaciones {
			$node = new PonX($operaciones.node, theTurtle);
};

pony returns [ASTNode node]: PONY operaciones {
			$node = new PonY($operaciones.node, theTurtle);
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

espera returns [ASTNode node]: ESPERA operaciones {
			$node = new Espera($operaciones.node, theTurtle);
}; 


operaciones returns [ASTNode node]:
		math
		{
			$node = $math.node;
		}
		|logic_Master
		{
			$node = $logic_Master.node;
		};


math returns [ASTNode node]:
		suma
		{
			$node = $suma.node;
		}	
		|
		diferencia
		{
			$node = $diferencia.node;
		}
		|
		producto
		{
			$node = $producto.node;
		}		
		|
		division
		{
			$node = $division.node;
		}
		|expression
		{
			$node = $expression.node;
		}
		;

suma returns [ASTNode node]: 
		{
			List<ASTNode> parameters = new ArrayList<ASTNode>();
		}
		SUMA
		PAR_OPEN 
		(t1=math {parameters.add($t1.node);})
		(t2=math {parameters.add($t2.node);})+
		PAR_CLOSE
		{
			$node = new Suma(parameters);
		}
;

producto returns [ASTNode node]: 
		{
			List<ASTNode> parameters = new ArrayList<ASTNode>();
		}
		PRODUCTO
		PAR_OPEN 
		(t1= math  {parameters.add($t1.node);})
		(t2= math  {parameters.add($t2.node);})+
		PAR_CLOSE
		{
			$node = new Producto(parameters);
		}
;

diferencia returns [ASTNode node]: 
		{
			List<ASTNode> parameters = new ArrayList<ASTNode>();
		}
		DIFERENCIA
		PAR_OPEN 
		(t1=math {parameters.add($t1.node);})
		(t2= math {parameters.add($t2.node);})+
		PAR_CLOSE
		{
			$node = new Diferencia(parameters);
		}
;
division returns [ASTNode node]: 
		{ 
			List<ASTNode> parameters = new ArrayList<ASTNode>();
		}
		DIVISION
		PAR_OPEN 
		(t1=math {parameters.add($t1.node);})
		(t2= math {parameters.add($t2.node);})+
		PAR_CLOSE
		{
			$node = new Cociente(parameters);
		}
;

logic_Master returns [ASTNode node]:
		y_logico  {$node = $y_logico.node;}
		|o_logico {$node = $o_logico.node;}
		|mayorque {$node = $mayorque.node;}
		|menorque {$node = $menorque.node;}
		|iguales  {$node = $iguales.node; }
		|logic    {$node = $logic.node;   }
;

y_logico returns [ASTNode node]:
		Y_LOGICO PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE{
			$node = new And($l1.node, $l2.node);
		};

o_logico returns [ASTNode node]:
		O_LOGICO PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE{
			$node = new Or($l1.node, $l2.node);
		};
		
mayorque returns [ASTNode node]:
		MAYORQUE PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE{
			$node = new Greater($l1.node, $l2.node);
		};
		
menorque returns [ASTNode node]:
		MENORQUE PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE{
			$node = new Lower($l1.node, $l2.node);
		};
		 
iguales returns [ASTNode node]:
		IGUALES PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE{
			$node = new Equal($l1.node, $l2.node);
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
		 C1=math {$node = $C1.node;}
		 (
		  GT  C2=math {$node = new Greater($C1.node,$C2.node);     }
		 |LT  C2=math {$node = new Lower($C1.node,$C2.node);       }
		 |GEQ C2=math {$node = new GreaterEqual($C1.node,$C2.node);}
		 |LEQ C2=math {$node = new LowerEqual($C1.node,$C2.node);  }
		 |EQ  C2=math {$node = new Equal($C1.node,$C2.node);       }
		 |DIF C2=math {$node = new Different($C1.node,$C2.node);   }		 
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
	  math { $node = $math.node; }
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


SUMA: 'suma';
DIFERENCIA: 'diferencia';
PRODUCTO: 'producto';
DIVISION: 'division';



PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';

AND: '&&';
OR: '||';
NOT: '!';

Y_LOGICO: 'Y';
O_LOGICO: 'O';
MAYORQUE: 'mayorque?';
MENORQUE: 'menorque?';
IGUALES: 'iguales?';


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
