package com.tec.logotec.compilador.ast;

import java.util.Map;

import com.tec.logotec.compilador.turtle.Turtle;

public class Rumbo implements ASTNode {
	private Turtle theTurtle;
	
	
	public Rumbo(Turtle turtle) {
		super();
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		return theTurtle.getHeading();
	}

}
