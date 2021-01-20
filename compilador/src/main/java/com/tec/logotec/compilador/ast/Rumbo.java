package com.tec.logotec.compilador.ast;

import com.tec.logotec.compilador.turtle.Turtle;

public class Rumbo implements ASTNode {
	private Turtle theTurtle;
	public int rumbo;
	
	
	public Rumbo(Turtle turtle) {
		super();
		this.theTurtle = turtle;
		this.rumbo = (int )Math.round(theTurtle.getHeading());
	}



	@Override
	public Object execute(Context symbolTable) {
		System.out.println(Math.round(theTurtle.getHeading()));
		return (int) Math.round(theTurtle.getHeading());
	}

}
