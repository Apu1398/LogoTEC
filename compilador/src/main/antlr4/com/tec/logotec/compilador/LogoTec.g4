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
	| var_inc			{$node = $var_inc.node;		   }
	| var_inc_by_numb   {$node = $var_inc_by_numb.node;}
	| println 	  		{$node = $println.node;        } 
	| flowFunctions     {$node = $flowFunctions.node;  }
	//| turtleFunctions   {$node = $turtleFunctions.node;}
	| type       		{$node = $type.node;   	   	   }
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

	 ID OPEN_SQUARE_BRACKET (t1=type{parameters.add($t1.node);} (t2=type{parameters.add($t2.node);})*)? CLOSE_SQUARE_BRACKET 
	{$node = new FunctionCall($ID.text,parameters); }
;
		
var_init returns [ASTNode node]: 
	DO ID type 
	{
		$node = new VarInitialization($ID.text, $type.node);
	}
;

var_assignment returns [ASTNode node]: 
	INIC ID ASSIGN type 
	{
		$node = new VarAssignment($ID.text, $type.node);
	}
;

var_inc returns [ASTNode node]:
	INC 
	OPEN_SQUARE_BRACKET 
	ID math
	CLOSE_SQUARE_BRACKET
	{
		$node = new VarInc($ID.text,$math.node);
		
	}
;


var_inc_by_numb returns [ASTNode node]:
	INC 
	OPEN_SQUARE_BRACKET 
	ID 
	CLOSE_SQUARE_BRACKET
	{
		$node = new VarIncByNumb($ID.text);
	}
;

/*----------------------------------------PROGRAM FLOW EXPRESSIONS----------------------------------------*/

flowFunctions returns [ASTNode node]: 	
	  if_ifelse 		{$node = $if_ifelse.node;      }
	| if_cond			{$node = $if_cond.node;		   }
	| loop 		  		{$node = $loop.node;           }
	| repite 		  	{$node = $repite.node;         }
	| doWhile			{$node = $doWhile.node;        }
;
 
if_ifelse returns [ASTNode node]: 
	IFELSE PAR_OPEN logic_Master PAR_CLOSE 
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
		$node = new Conditional($logic_Master.node, ifBody, elseBody);
	}
;

if_cond returns [ASTNode node]: 
	IF PAR_OPEN logic_Master PAR_CLOSE 
	{
		List<ASTNode> ifBody = new ArrayList<ASTNode>();
	}
	OPEN_SQUARE_BRACKET 
	( s1=statement { ifBody.add($s1.node); } )* 
	CLOSE_SQUARE_BRACKET
	{
		$node = new IfConditional($logic_Master.node, ifBody);
	}
;

loop returns [ASTNode node]:
	WHILE PAR_OPEN logic_Master PAR_CLOSE 
	{
		List<ASTNode> body = new ArrayList<ASTNode>();
	}
	OPEN_SQUARE_BRACKET 
	( statement { body.add($statement.node); } )*   
	CLOSE_SQUARE_BRACKET
	{
		$node = new Loop($logic_Master.node, body);	
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
	PAR_OPEN logic_Master PAR_CLOSE
	{
		$node = new DoWhile($logic_Master.node, body);	
	}
;

/*----------------------------------------PROGRAM FLOW EXPRESSIONS----------------------------------------*/

/*-------------------------------------------TURTLE EXPRESSIONS------------------------------------------*/

/*
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

avanza returns [ASTNode node]: AVANZA math {
			$node = new Avanza($math.node, theTurtle);
			
};

retrocede returns [ASTNode node]: RETROCEDE math {
			$node = new Retrocede($math.node, theTurtle);
};

giraderecha returns [ASTNode node]: GIRADERECHA math {
			$node = new GiraDerecha($math.node, theTurtle);
};

giraizquierda returns [ASTNode node]: GIRAIZQUIERDA math {
			$node = new GiraIzquierda($math.node, theTurtle);
};

ponpos returns [ASTNode node]: 
			(PONPOS OPEN_SQUARE_BRACKET t1=math t2=math CLOSE_SQUARE_BRACKET
		    |
		    PONPOS t1=math t2=math) {
		    	$node = new PonPos($t1.node, $t2.node, theTurtle);
		    };
		    
ponrumbo returns [ASTNode node]: PONRUMBO math {
			$node = new PonRumbo($math.node, theTurtle);
};


ponx returns [ASTNode node]: PONX math {
			$node = new PonX($math.node, theTurtle);
};

pony returns [ASTNode node]: PONY math {
			$node = new PonY($math.node, theTurtle);
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

espera returns [ASTNode node]: ESPERA math {
			$node = new Espera($math.node, theTurtle);
}; 

 */


/*
rumbo returns [ASTNode node]: RUMBO {
			$node = new Rumbo(theTurtle);
};*/

/*-------------------------------------------TURTLE EXPRESSIONS------------------------------------------*/

type returns [ASTNode node]:
		math
		{
			$node = $math.node;
		}
		|logic_Master
		{
			$node = $logic_Master.node;
		}
		|stringTerm
		{
			$node = $stringTerm.node;
		}
;

/*-----------------------------------------LOGIC EXPRESSIONS----------------------------------------- */

logic_Master returns [ASTNode node]:
		y_logico  	{$node = $y_logico.node;   }
		|o_logico 	{$node = $o_logico.node;   }
		|logic    	{$node = $logic.node;      }
		|booleanTerm{$node = $booleanTerm.node;}
;

y_logico returns [ASTNode node]:
		Y_LOGICO PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE
		{
			$node = new And($l1.node, $l2.node);
		};

o_logico returns [ASTNode node]:
		O_LOGICO PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE
		{
			$node = new Or($l1.node, $l2.node);
		};

logicFunction returns [ASTNode node]:
		mayorque {$node = $mayorque.node;}
		|
		menorque {$node = $menorque.node;}
		|
		iguales  {$node = $iguales.node; }
;
		
mayorque returns [ASTNode node]:
		MAYORQUE PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE
		{
			$node = new Greater($l1.node, $l2.node);
		};
		
menorque returns [ASTNode node]:
		MENORQUE PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE
		{
			$node = new Lower($l1.node, $l2.node);
		};
		 
iguales returns [ASTNode node]:
		IGUALES PAR_OPEN l1 = logic_Master l2=logic_Master PAR_CLOSE
		{
			$node = new Equal($l1.node, $l2.node);
		};

logic returns [ASTNode node]:
		 f1=comparison {$node = $f1.node;}
		 (
		 AND f2=comparison {$node = new And($f1.node,$f2.node);}
		 |
		 OR f2=comparison  {$node = new Or($f1.node,$f2.node); }
		 )*
;
	  		 	
comparison returns [ASTNode node]:
		      C1=math {$node = $C1.node;						   }
		 (
		  GT  C2=math {$node = new Greater($C1.node,$C2.node);     }
		 |LT  C2=math {$node = new Lower($C1.node,$C2.node);       }
		 |GEQ C2=math {$node = new GreaterEqual($C1.node,$C2.node);}
		 |LEQ C2=math {$node = new LowerEqual($C1.node,$C2.node);  }
		 |EQ  C2=math {$node = new Equal($C1.node,$C2.node);       }
		 |DIF C2=math {$node = new Different($C1.node,$C2.node);   }
		 )* 
		 |booleanTerm {$node = $booleanTerm.node;				   }
;	
 
/*-----------------------------------------LOGIC EXPRESSIONS----------------------------------------- */
 
/*---------------------------------------ARITMETIC EXPRESSIONS--------------------------------------- */
mathFunction returns [ASTNode node]:
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
		|
		potencia
		{
			$node = $potencia.node;
		}
		|
		azar
		{
			$node = $azar.node;
		}
		|
		redondea
		{
			$node = $redondea.node;
		}
		|
		menos
		{
			$node = $menos.node;
		}
		;

suma returns [ASTNode node]: 
		{
			List<ASTNode> parameters = new ArrayList<ASTNode>();
		}
		SUMA
		PAR_OPEN 
		(t1= math {parameters.add($t1.node);})
		(t2= math {parameters.add($t2.node);})+
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
		(t1= math {parameters.add($t1.node);})
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
		(t1= math {parameters.add($t1.node);})
		(t2= math {parameters.add($t2.node);})+
		PAR_CLOSE
		{
			$node = new Cociente(parameters);
		}
; 
 
 
potencia returns [ASTNode node]: 
		POTENCIA
		PAR_OPEN 
		(t1= math )
		(t2= math )
		PAR_CLOSE
		{
			$node = new Potencia($t1.node, $t2.node);
		}
;  
 

azar returns [ASTNode node]: 
		AZAR
		PAR_OPEN 
		t1= math
		PAR_CLOSE
		{
			$node = new Azar($t1.node);
		}
;  


redondea returns [ASTNode node]:
		REDONDEA
		PAR_OPEN 
		t1= math
		PAR_CLOSE
		{
			$node = new Redondea($t1.node);
		}
;
 
menos returns [ASTNode node]:
		MENOS
		PAR_OPEN 
		t1= math
		PAR_CLOSE
		{
			$node = new Menos($t1.node);
		}
;
 
 
math returns [ASTNode node]:
	t1=mathFactor {$node = $t1.node;} 
	(
	(PLUS t2=mathFactor {$node = new Addition($node, $t2.node);})
	| 
	(MINUS t2=mathFactor {$node = new Subtraction($node, $t2.node);})
	)*   
;

mathFactor returns [ASTNode node]: 
	t1=numberTerm {$node = $t1.node;} 
	(
	(MULT t2=numberTerm {$node = new Multiplication($node, $t2.node);})
	|
	(DIV t2=numberTerm  {$node = new Division($node, $t2.node);})
	)* 
;


/*---------------------------------------ARITMETIC EXPRESSIONS--------------------------------------- */

/*------------------------------------------NUMBER VALUES------------------------------------------ */
numberTerm returns [ASTNode node]:
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
	|PAR_OPEN 
	math { $node = $math.node; }
	PAR_CLOSE
	|mathFunction
	{
		$node = $mathFunction.node;
	}
;
/*------------------------------------------NUMBER VALUES------------------------------------------ */

/*------------------------------------------BOOLEAN VALUES------------------------------------------ */


booleanTerm returns [ASTNode node]:
	ID 
	{
	 	$node = new VarReference($ID.text);
	}
	|BOOLEAN
	{
		$node = new Constant(Boolean.parseBoolean($BOOLEAN.text));
	}
	|
	logicFunction 
	{
		$node = $logicFunction.node;
	}
;

/*------------------------------------------BOOLEAN VALUES------------------------------------------ */



/*------------------------------------------STRING VALUES------------------------------------------ */
stringTerm returns [ASTNode node]:
	ID 
	{
	 	$node = new VarReference($ID.text);
	}
	|STRING
	{
		$node = new Constant($STRING.text);	
	}
	
;


/*------------------------------------------STRING VALUES------------------------------------------ */

println returns [ASTNode node]: 
	PRINTLN type 
	{
		$node  = new Println($type.node);
	};

comment returns [ASTNode node]:
	(COMMENT
	|
	LINE_COMMENT){
		$node = new Comment();
	};

//FUNCTIONS TOKEN
DEFINE: 'PARA';
END_DEFINE: 'FIN';
//FUNCTIONS TOKEN

PRINTLN: 'println';


//Turtle TOKENS
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
//Turtle TOKENS


//PROGRAM FLOW TOKENS
IFELSE: 'SiSino';
IF: 'Si';

WHILE: 'Mientras' | 'Hasta';
REPITE: 'repite';
DOWHILE: 'HazMientras' | 'HazHasta';
//PROGRAM FLOW FUNCTIONS TOKENS


//VAR TOKENS
DO: 'Haz';
INIC: 'Inic';
INC: 'Inc';
//VAR TOKENS

// ----------------------------------------ARITMETIC TOKENS-----------------------------------
SUMA: 'suma';
DIFERENCIA: 'diferencia';
PRODUCTO: 'producto';
DIVISION: 'division';
POTENCIA: 'potencia';
AZAR : 'azar';
REDONDEA: 'redondea';
MENOS: 'menos';

PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
// ----------------------------------------ARITMETIC TOKENS-----------------------------------


//------------------------------------------LOGIC TOKENS--------------------------------------
AND: '&&';
OR: '||';

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
DIF: '=!';
//------------------------------------------LOGIC TOKENS--------------------------------------

//-----------------------------------------SIMBOL TOKENS---------------------------------------
ASSIGN: '=';
COMMA: ',';
SEMICOLON: ';';


BRACKET_OPEN: '{';
BRACKET_CLOSE: '}';

PAR_OPEN: '(';
PAR_CLOSE: ')';

OPEN_SQUARE_BRACKET: '[';
CLOSE_SQUARE_BRACKET: ']';
//-----------------------------------------SIMBOL TOKENS--------------------------------------- 
 
//--------------------------------------VAR VALUES TOKENS--------------------------------------
BOOLEAN: 'true' | 'false';

ID: [a-zA-Z_][a-zA-Z0-9_]*;

STRING: '"' ~('"')* '"';
NUMBER: [0-9]+;
//--------------------------------------VAR VALUES TOKENS--------------------------------------

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