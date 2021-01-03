package com.tec.logotec.compilador.ast;
import java.util.Map;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class QuitaGoma implements ASTNode {
	
	private Turtle theTurtle;
	
	

	public QuitaGoma(Turtle theTurtle) {
		super();
		this.theTurtle = theTurtle;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.setColor(theTurtle.userColor);       
	        theTurtle.setPenWidth(1); 
		}		
		return null;
	}

}
