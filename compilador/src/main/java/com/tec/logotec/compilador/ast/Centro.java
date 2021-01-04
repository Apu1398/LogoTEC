package com.tec.logotec.compilador.ast;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class Centro implements ASTNode {
	
	private Turtle theTurtle;
	
	

	public Centro(Turtle turtle) {
		super();
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.goTo(0,0);
		}		
		return null;
	}

}
