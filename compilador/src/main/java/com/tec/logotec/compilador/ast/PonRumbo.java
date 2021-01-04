package com.tec.logotec.compilador.ast;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonRumbo implements ASTNode {
	
	private ASTNode data;
	private Turtle theTurtle;
	
	

	public PonRumbo(ASTNode data, Turtle turtle) {
		super();
		this.data = data;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		int movement = (int)data.execute(symbolTable);
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.setHeading(movement);
		}		
		return null;
	}

}
