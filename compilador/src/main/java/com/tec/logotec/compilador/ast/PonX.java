package com.tec.logotec.compilador.ast;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonX implements ASTNode {
	
	private ASTNode dataX;
	private Turtle theTurtle;
	
	

	public PonX(ASTNode dataX, Turtle turtle) {
		super();
		this.dataX = dataX;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		int x = (int)dataX.execute(symbolTable);
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.goTo(x,theTurtle.getLocation().getY()*-1);
		}		
		return null;
	}

}
