package com.tec.logotec.compilador.ast;
import java.awt.Color;
import java.util.Map;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonColorLapiz implements ASTNode {
	
	private ASTNode data;
	private Turtle theTurtle;
	
	

	public PonColorLapiz(ASTNode data, Turtle turtle) {
		super();
		this.data = data;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			Color color = null;
			switch(data.toString()) {
			case "AZUL":
				color = new Color(0,0,255);
			case "BLANCO":
				color = new Color(255,255,255);
			case "MARRON":
				color = new Color(51,25,0);
			case "CYAN":
				color = new Color(0,255,255);
			case "GRIS":
				color = new Color(96,96,96);
			case "AMARILLO":
				color = new Color(255,255,0);
			case "NEGRO":
				color = new Color(0,0,0);
			case "ROJO":
				color = new Color(255,0,0);
			case "VERDE":
				color = new Color(0,255,0);
			}
			theTurtle.userColor = color;
			theTurtle.setColor(color);
			
		}		
		return null;
	}
}
