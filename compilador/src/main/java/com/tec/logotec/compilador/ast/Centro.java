package com.tec.logotec.compilador.ast;
import java.util.Map;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class Centro implements ASTNode {
	
	private Turtle theTurtle;
	
	

	public Centro(ASTNode data, Turtle turtle) {
		super();
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.goTo(0,0);
		}		
		return null;
	}

}
