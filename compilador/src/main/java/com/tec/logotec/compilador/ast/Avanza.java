package com.tec.logotec.compilador.ast;
import java.util.Map;

import com.tec.logotec.compilador.turtle.Turtle;

public class Avanza implements ASTNode {
	
	private ASTNode data;
	private Turtle theTurtle;
	
	

	public Avanza(ASTNode data, Turtle turtle) {
		super();
		this.data = data;
		this.theTurtle = turtle;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		theTurtle.forward((int)data.execute(symbolTable));
		return null;
	}

}
