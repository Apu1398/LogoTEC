package com.tec.logotec.compilador.ast;
import java.awt.Color;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonColorLapiz implements ASTNode {
	
	private String data;
	private Turtle theTurtle;
	
	

	public PonColorLapiz(String data, Turtle turtle) {
		super();
		this.data = data;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			Color color = null;	
			switch(data) {
			case "azul":
				color = new Color(26, 80, 139);
				break;
			case "blanco":
				color = new Color(255,255,255);
				break;
			case "marron":
				color = new Color(125, 94, 42);
				break;
			case "cian":
				color = new Color(67, 216, 201);
				break;
			case "gris":
				color = new Color(55, 64, 69);
				break;
			case "amarillo":
				color = new Color(253, 219, 58);
				break;
			case "negro":
				color = new Color(0,0,0);
				break;
			case "rojo":
				color = new Color(236, 1, 1);
				break;
			case "verde":
				color = new Color(0,255,0);
				break;
			case "morado":
				color = new Color(114, 27, 101);
				break;
			case "naranja":
				color = new Color(244, 89, 5);
				break;
			}
			if (color != null) {
			theTurtle.userColor = color;
			theTurtle.setColor(theTurtle.userColor);
			}
			
		}		
		return null;
	}
}
