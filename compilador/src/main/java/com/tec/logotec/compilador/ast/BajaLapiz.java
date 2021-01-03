package com.tec.logotec.compilador.ast;
import java.util.Map;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class BajaLapiz implements ASTNode {
	
	private Turtle theTurtle;
	
	

	public BajaLapiz(Turtle theTurtle) {
		super();
		this.theTurtle = theTurtle;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.putPenDown(); 
		}		
		return null;
	}

}
