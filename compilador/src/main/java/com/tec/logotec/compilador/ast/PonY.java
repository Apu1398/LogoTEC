package com.tec.logotec.compilador.ast;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonY implements ASTNode {
	
	private ASTNode dataY;
	private Turtle theTurtle;
	
	

	public PonY(ASTNode dataY, Turtle turtle) {
		super();
		this.dataY = dataY;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		int y = (int)dataY.execute(symbolTable);
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.goTo(theTurtle.getLocation().getX(), y);
		}		
		return null;
	}

}
