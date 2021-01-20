package com.tec.logotec.compilador.ast;
import com.tec.logotec.compilador.window.CompilerState;

import com.tec.logotec.compilador.turtle.Turtle;
import com.tec.logotec.compilador.turtle.World;

public class BorraPantalla implements ASTNode {
	
	private Turtle theTurtle;
	private World theWorld;
	
	

	public BorraPantalla(World theWorld, Turtle theTurtle) {
		super();
		this.theTurtle = theTurtle;
		this.theWorld = theWorld;
	}



	@Override
	public Object execute(Context symbolTable) {
		
		if (CompilerState.getCompilerStatus() && CompilerState.canIDoSomething()) {
			theWorld.eraseGround();
			theWorld.turtleMoved();
		}		
		return null;
	}

}
