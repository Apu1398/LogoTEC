package com.tec.logotec.compilador.ast;
import java.util.Map;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class SubeLapiz implements ASTNode {
	
	private Turtle theTurtle;
	
	

	public SubeLapiz() {
		super();
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.pickPenUp(); 
		}		
		return null;
	}

}
