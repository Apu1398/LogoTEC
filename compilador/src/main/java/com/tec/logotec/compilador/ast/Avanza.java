package com.tec.logotec.compilador.ast;
import com.tec.logotec.compilador.window.CompilerState;


import com.tec.logotec.compilador.turtle.Turtle;

public class Avanza implements ASTNode {
	
	private ASTNode data;
	protected Turtle theTurtle;
	

	public Avanza(ASTNode data, Turtle turtle) {
		super();
		this.data = data;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Context symbolTable) {
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			int movement = (int)data.execute(symbolTable);
			theTurtle.forward(movement);
		}		
		return null;
	}

}
