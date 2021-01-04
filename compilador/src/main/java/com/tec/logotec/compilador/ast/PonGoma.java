package com.tec.logotec.compilador.ast;
import java.awt.Color;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonGoma implements ASTNode {
	
	private Turtle theTurtle;
	
	

	public PonGoma(Turtle theTurtle) {
		super();
		this.theTurtle = theTurtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.setColor(new Color(255,255,255));
	        theTurtle.setPenWidth(2);
		}		
		return null;
	}

}
