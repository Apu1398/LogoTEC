package com.tec.logotec.compilador.ast;
import java.awt.Color;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonColorLapiz implements ASTNode {
	
	private String data;
	private Turtle theTurtle;
	
	

	public PonColorLapiz(String Color, Turtle turtle) {
		super();
		this.data = Color;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			Color color = null;
			System.out.println(data);
			switch(data) {
			case "azul":
				color = new Color(0,0,255);
				break;
			case "blanco":
				color = new Color(255,255,255);
				break;
			case "marron":
				color = new Color(51,25,0);
				break;
			case "cian":
				color = new Color(0,255,255);
				break;
			case "gris":
				color = new Color(96,96,96);
				break;
			case "amarillo":
				color = new Color(255,255,0);
				break;
			case "negro":
				color = new Color(0,0,0);
				break;
			case "rojo":
				color = new Color(255,0,0);
				break;
			case "verde":
				color = new Color(0,255,0);
				break;
			}
			theTurtle.userColor = color;
			theTurtle.setColor(theTurtle.userColor);
			
		}		
		return null;
	}
}
