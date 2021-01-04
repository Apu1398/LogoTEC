package com.tec.logotec.compilador.ast;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class PonPos implements ASTNode {
	
	private ASTNode dataX;
	private ASTNode dataY;
	private Turtle theTurtle;
	
	

	public PonPos(ASTNode dataX, ASTNode dataY, Turtle turtle) {
		super();
		this.dataX = dataX;
		this.dataY = dataY;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		int x = (int)dataX.execute(symbolTable);
		int y = (int)dataY.execute(symbolTable);
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.goTo(x,y);
		}		
		return null;
	}

}
