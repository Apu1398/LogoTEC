package com.tec.logotec.compilador.ast;
import java.util.Map;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;

public class GiraIzquierda implements ASTNode {
	
	private ASTNode data;
	private Turtle theTurtle;
	
	

	public GiraIzquierda(ASTNode data, Turtle turtle) {
		super();
		this.data = data;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		int movement = (int)data.execute(symbolTable);
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theTurtle.left(movement);
		}		
		return null;
	}

}
